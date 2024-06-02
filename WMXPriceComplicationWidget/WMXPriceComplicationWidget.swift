//
//  WMXPriceComplicationWidget.swift
//  WMXPriceComplicationWidget
//
//  Created by mgarciate on 2/6/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tokenPrice: 1.1)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), tokenPrice: 1.1)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        CoinGeckoNetworkManager.shared.fetchWXMTokenPrice { price in
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, tokenPrice: price ?? 1.09)
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let tokenPrice: Double
}

struct WMXPriceComplicationWidgetEntryView : View {
    var entry: Provider.Entry
    let tokenSymbol = "WXM"

    var body: some View {
        
        AccessoryWidgetBackground()
        Text(attributedWXMPriceString)
    }
    
    var attributedWXMPriceString: AttributedString {
        let font = UIFont.systemFont(ofSize: CGFloat(.largeTitleFontSize))
        let value = String(format: "$%.2f", entry.tokenPrice)
        var attributedString = AttributedString("\(tokenSymbol) \(value)")
        attributedString.font = font
        attributedString.foregroundColor = Color(colorEnum: .text)
        
        if let unitRange = attributedString.range(of: value) {
            let superScriptFont = UIFont.systemFont(ofSize: CGFloat(.largeTitleFontSize), weight: .bold)
            attributedString[unitRange].foregroundColor = Color(colorEnum: .darkGrey)
            attributedString[unitRange].font = superScriptFont
        }
        
        return attributedString
    }
}

struct WMXPriceComplicationWidget: Widget {
    let kind: String = "WMXPriceComplicationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WMXPriceComplicationWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("WXM price")
        .description("Show the WXM token price")
        .supportedFamilies([.accessoryInline, .accessoryCorner])
    }
}

#Preview(as: .accessoryInline) {
    WMXPriceComplicationWidget()
} timeline: {
    SimpleEntry(date: .now, tokenPrice: 1.15)
}
