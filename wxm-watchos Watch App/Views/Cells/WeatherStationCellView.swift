//
//  WeatherStationCellView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import SwiftUI

struct WeatherStationCellView: View {
    let device: NetworkDevicesResponse
    private let unitsManager = WeatherUnitsManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: CGFloat(8.0)) {
                if let _ = device.address {
                    Text(FontIcon.hexagon.rawValue)
                        .font(.fontAwesome(font: .FAPro, size: 10.0))
                        .foregroundColor(Color(colorEnum: .darkBg))
                }
                Text(device.address ?? device.name)
                    .font(.system(size: CGFloat(.caption)))
                    .foregroundColor(Color(colorEnum: .darkBg))
                    .lineLimit(1)
            }
            .WXMCardStyle(backgroundColor: Color(colorEnum: .blueTint),
                          insideHorizontalPadding: CGFloat(8),
                          insideVerticalPadding: CGFloat(2),
                          cornerRadius: CGFloat(.buttonCornerRadius))
            HStack {
                StationLastActiveView(configuration: StationLastActiveView.Configuration(
                    lastActiveAt: device.attributes.lastActiveAt,
                    icon: .wifi,
                    stateColor: activeStateColor(isActive: device.attributes.isActive),
                    tintColor: activeStateTintColor(isActive: device.attributes.isActive))
                )
                Spacer()
                if let temperature = device.currentWeather?.temperature {
                    Text(attributedTemperatureString)
                } else {
                    Text("-ºC")
                }
            }
        }
    }
    
    var attributedTemperatureString: AttributedString {
        let font = UIFont.systemFont(ofSize: CGFloat(.largeFontSize))
        let temperatureLiterals: WeatherValueLiterals = WeatherField.temperature.weatherLiterals(from: device.currentWeather, unitsManager: unitsManager) ?? ("", "")
        
        var attributedString = AttributedString("\(temperatureLiterals.value)\(temperatureLiterals.unit)")
        attributedString.font = font
        attributedString.foregroundColor = Color(colorEnum: .text)
        
        if let unitRange = attributedString.range(of: temperatureLiterals.unit) {
            let superScriptFont = UIFont.systemFont(ofSize: CGFloat(.largeFontSize))
            attributedString[unitRange].foregroundColor = Color(colorEnum: .darkGrey)
            attributedString[unitRange].font = superScriptFont
        }
        
        return attributedString
    }
}

#Preview {
    WeatherStationCellView(device: NetworkDevicesResponse.dummyData[0])
}
