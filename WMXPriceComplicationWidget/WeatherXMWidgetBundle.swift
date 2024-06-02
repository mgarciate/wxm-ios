//
//  WeatherXMWidgetBundle.swift
//  WMXPriceComplicationWidgetExtension
//
//  Created by mgarciate on 2/6/24.
//

import WidgetKit
import SwiftUI

@main
struct WeatherXMWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WMXPriceComplicationWidget()
        TotalWeatherStationsWidget()
    }
}
