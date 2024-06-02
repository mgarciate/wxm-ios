//
//  TotalWeatherStationsWidget.swift
//  WMXPriceComplicationWidgetExtension
//
//  Created by mgarciate on 2/6/24.
//

import WidgetKit
import SwiftUI

struct TotalStationsTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> TotalStationsEntry {
        TotalStationsEntry(date: Date(), total: 7000)
    }

    func getSnapshot(in context: Context, completion: @escaping (TotalStationsEntry) -> ()) {
        let entry = TotalStationsEntry(date: Date(), total: 7000)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let stats = try? await NetworkService<NetworkStatsResponse>().get(endpoint: .networkStats)
            let currentDate = Date()
            let entry = TotalStationsEntry(date: currentDate, total: stats?.weatherStations?.onboarded?.total ?? 0)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            await MainActor.run {
                completion(timeline)
            }
        }
//        completion(Timeline(entries: [TotalStationsEntry(date: Date(), total: 7000)], policy: .atEnd))
    }
}

struct TotalStationsEntry: TimelineEntry {
    let date: Date
    let total: Int
}

struct TotalWeatherStationsWidgetEntryView : View {
    var entry: TotalStationsTimelineProvider.Entry

    var body: some View {
        Gauge(value: Double(entry.total),
              in: 0...10000) {
            Text("10k")
        } currentValueLabel: {
            Text("\(entry.total)")
        }
        .gaugeStyle(.circular)

    }
}

struct TotalWeatherStationsWidget: Widget {
    let kind: String = "TotalWeatherStationsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TotalStationsTimelineProvider()) { entry in
            TotalWeatherStationsWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Total Weather Stations")
        .description("Show the total Weather Stations in the WeatherXM network")
        .supportedFamilies([.accessoryCircular, .accessoryCorner])
    }
}

#Preview(as: .accessoryCircular) {
    TotalWeatherStationsWidget()
} timeline: {
    TotalStationsEntry(date: .now, total: 7000)
}
