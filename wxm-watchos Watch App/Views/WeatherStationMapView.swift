//
//  WeatherStationMapView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import SwiftUI
import MapKit

struct WeatherStationMapView: View {
    let location: CLLocationCoordinate2D
    
    var body: some View {
        Map(initialPosition: .region(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))), interactionModes: .zoom) {
            Marker("", image: "weatherXMLogo", coordinate: location)
                .tint(.blue)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WeatherStationMapView(location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
}
