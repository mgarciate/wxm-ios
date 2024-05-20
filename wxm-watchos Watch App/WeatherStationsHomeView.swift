//
//  WeatherStationsHomeView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 19/5/24.
//

import SwiftUI

struct WeatherStationsHomeView: View {
    var body: some View {
        NavigationStack {
            List(Range(1...10)) { index in
                NavigationLink {
                    StationDetailsContainerView(index: index)
                } label: {
                    Text("\(index) - Hello, World!")
                }
            }
            .navigationTitle("Select a Station")
            .listStyle(.carousel)
        }
    }
}

#Preview {
    WeatherStationsHomeView()
}
