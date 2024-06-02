//
//  CurrentWeatherView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import SwiftUI

struct CurrentWeatherView: View {
    let device: NetworkDevicesResponse
    private let unitsManager = WeatherUnitsManager()
    
    var body: some View {
        VStack(spacing: CGFloat(Dimension.defaultSpacing)) {
            Group {
                HStack(spacing: 0.0) {
                    VStack(spacing: 0.0) {
                        
                        Text(device.name)
                            .font(.system(size: CGFloat(.caption)))
                        
                        Image(device.currentWeather?.icon ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: CGFloat(.weatherIconMinDimension), height: CGFloat(.weatherIconMinDimension))
                        
                        Text(attributedTemperatureString)
                            .lineLimit(1)
                            .fixedSize()
                            .minimumScaleFactor(0.8)
                        
                        Text(attributedFeelsLikeString)
                            .fixedSize()
                    }
                }
            }
            .WXMCardStyle(backgroundColor: Color(colorEnum: .top),
                          insideHorizontalPadding: CGFloat(.defaultSidePadding),
                          insideVerticalPadding: CGFloat(.minimumPadding),
                      cornerRadius: CGFloat(.cardCornerRadius))
        }
    }
    
    var attributedTemperatureString: AttributedString {
        let font = UIFont.systemFont(ofSize: CGFloat(.largeTitleFontSize))
        let temperatureLiterals: WeatherValueLiterals = WeatherField.temperature.weatherLiterals(from: device.currentWeather, unitsManager: unitsManager) ?? ("", "")
        
        var attributedString = AttributedString("\(temperatureLiterals.value)\(temperatureLiterals.unit)")
        attributedString.font = font
        attributedString.foregroundColor = Color(colorEnum: .text)
        
        if let unitRange = attributedString.range(of: temperatureLiterals.unit) {
            let superScriptFont = UIFont.systemFont(ofSize: CGFloat(.largeTitleFontSize))
            attributedString[unitRange].foregroundColor = Color(colorEnum: .darkGrey)
            attributedString[unitRange].font = superScriptFont
        }
        
        return attributedString
    }
    
    var attributedFeelsLikeString: AttributedString {
        let feelsLikeLiteral = LocalizableString.feelsLike.localized
        let temperatureLiterals: WeatherValueLiterals = WeatherField.feelsLike.weatherLiterals(from: device.currentWeather, unitsManager: unitsManager) ?? ("", "")
        
        var attributedString = AttributedString("\(feelsLikeLiteral) \(temperatureLiterals.value)\(temperatureLiterals.unit)")
        attributedString.font = .system(size: CGFloat(.littleCaption))
        attributedString.foregroundColor = Color(colorEnum: .darkestBlue)
        
        if let temperatureRange = attributedString.range(of: temperatureLiterals.value) {
            attributedString[temperatureRange].font = .system(size: CGFloat(.smallFontSize), weight: .bold)
            attributedString[temperatureRange].foregroundColor = Color(colorEnum: .text)
        }
        
        if let unitRange = attributedString.range(of: temperatureLiterals.unit) {
            attributedString[unitRange].font = .system(size: CGFloat(.littleCaption))
            attributedString[unitRange].foregroundColor = Color(colorEnum: .darkGrey)
        }
        
        return attributedString
    }
}

#Preview {
    CurrentWeatherView(device: NetworkDevicesResponse.dummyData[0])
}
