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
    var data: [WeatherItem] = {
        var data = [WeatherItem] ()
        let date = Date()
        (1...24).forEach { index in
            guard let newDate = Calendar.current.date(byAdding: .hour, value: -index, to: date) else { return }
            data.append(
                WeatherItem(
                    date: newDate,
                    temperature: Double(Int.random(in: (5...25)))
                )
            )
        }
        return data
    }()
    
    var body: some View {
        VStack {
            Chart(data) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Temperature", item.temperature)
                )
                RuleMark(y: .value("Average", 15.0))
                    .foregroundStyle(.red)
            }
            .padding(.horizontal)
            Text("ºC Last 24h")
                .font(.system(size: CGFloat(.littleCaption)))
        }
    }
}

#Preview {
    WeatherStationTemperatureChartView()
}
