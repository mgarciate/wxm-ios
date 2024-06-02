//
//  WeatherStationTemperatureChartView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import SwiftUI
import Charts

struct WeatherItem: Identifiable {
    public var id: String {
        date.toTimestamp()
    }
    
    let date: Date
    let temperature: Double
}

struct WeatherStationTemperatureChartView: View {
    let device: NetworkDevicesResponse
    
    var data: [WeatherItem] = {
        var data = [WeatherItem] ()
        let date = Date()
        var temp = 12.0
        (1...24).forEach { index in
            guard let newDate = Calendar.current.date(byAdding: .hour, value: -index, to: date) else { return }
            data.append(
                WeatherItem(
                    date: newDate,
                    temperature: temp
                )
            )
            if index < 12 { temp += Double.random(in: (0.2...1)) }
            else if index >= 10, index < 14 {}
            else { temp -= Double.random(in: (0.2...1.5)) }
        }
        return data
    }()
    
    var body: some View {
        if device.relation == nil {
            HiddenContentView(deviceName: device.name)
        } else {
            VStack {
                Chart(data) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Temperature", item.temperature)
                    )
                    .interpolationMethod(.catmullRom)
                    RuleMark(y: .value("Average", 15.0))
                        .foregroundStyle(.red)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine() // Keep the grid lines
                        AxisValueLabel(format: .dateTime.hour(), centered: true) // Format to show only time
                    }
                }
                .padding(.horizontal)
                Text("ºC Last 24h")
                    .font(.system(size: CGFloat(.littleCaption)))
            }
        }
    }
}

#Preview {
    WeatherStationTemperatureChartView(device: NetworkDevicesResponse.dummyData[0])
}
