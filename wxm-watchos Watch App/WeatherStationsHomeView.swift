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
                    VStack {
                        Text("3 letters name")
                        HStack(spacing: CGFloat(8.0)) {
                            Text(FontIcon.hexagon.rawValue)
                                .font(.fontAwesome(font: .FAPro, size: 10.0))
                                .foregroundColor(Color.white)

                            Text("address")
                                .font(.system(size: CGFloat(10.0)))
                                .foregroundColor(Color.white)
                                .lineLimit(1)
                        }
                    }
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
