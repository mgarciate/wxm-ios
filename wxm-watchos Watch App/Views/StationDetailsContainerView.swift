//
//  StationDetailsContainerView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 19/5/24.
//

import SwiftUI

struct StationDetailsContainerView: View {
    let device: NetworkDevicesResponse
    
    var body: some View {
        TabView {
            CurrentWeatherView(device: device)
            WeatherStationTemperatureChartView(device: device)
            if let latitude = device.location?.lat, let longitude = device.location?.lon {
                WeatherStationMapView(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
        }
        .tabViewStyle(.verticalPage)
        .background {
            Color(colorEnum: .top)
        }
    }
}

#Preview {
    StationDetailsContainerView(device: NetworkDevicesResponse.dummyData[0])
}
