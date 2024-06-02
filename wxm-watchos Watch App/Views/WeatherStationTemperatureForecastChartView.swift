//
//  WeatherStationTemperatureForecastChartView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 2/6/24.
//

import SwiftUI
import Charts

struct PointWeatherItem: Identifiable {
    let id = UUID().uuidString
    let day: String
    let hour: Double
    let temperature: Double
}

struct WeatherStationTemperatureForecastChartView: View {
    let device: NetworkDevicesResponse
    
    var data: [PointWeatherItem] = {
        var data = [PointWeatherItem]()
        [3, 4, 5, 6, 7, 8, 9].forEach{ day in
            (0...23).forEach{ hour in
                data.append(PointWeatherItem(day: "\(day)", hour: Double(hour), temperature: Double.random(in: (12...20))))
            }
        }
        return data
    }()
    
    var body: some View {
        if device.relation == nil {
            HiddenContentView(deviceName: device.name)
        } else {
            VStack {
                Chart(data) {
                    PointMark(
                        x: .value("Hour of the day", $0.day),
                        y: .value("ºC", $0.temperature)
                    )
                }
                .padding(.horizontal)
                Text("ºC Next 7 days")
                    .font(.system(size: CGFloat(.littleCaption)))
            }
        }
    }
}

#Preview {
    WeatherStationTemperatureForecastChartView(device: NetworkDevicesResponse.dummyData[0])
}
