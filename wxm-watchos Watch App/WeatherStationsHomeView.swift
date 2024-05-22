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
                    VStack(alignment: .leading) {
                        Text("3 letters name")
                            .lineLimit(1)
                        HStack {
//                            HStack(spacing: 0.0) {
//                                Image(asset: .wifi)
//                                    .renderingMode(.template)
//                                    .foregroundColor(Color(colorEnum: configuration.stateColor))
//
//                                Text(configuration.lastActiveAt?.lastActiveTime() ?? "-")
//                                    .font(.system(size: CGFloat(.caption)))
//                                    .foregroundColor(Color(colorEnum: configuration.stateColor))
//                                    .padding(.trailing, CGFloat(.smallSidePadding))
//                            }
//                            .WXMCardStyle(backgroundColor: Color(colorEnum: configuration.tintColor),
//                                          insideHorizontalPadding: 0.0,
//                                          insideVerticalPadding: 0.0,
//                                          cornerRadius: CGFloat(.buttonCornerRadius))
                            HStack(spacing: 0.0) {
                                Image(asset: .wifi)
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue)

                                Text("lastActiveAt")
                                    .font(.system(size: CGFloat(10.0)))
                                    .foregroundColor(Color.green)
                                    .padding(.trailing, CGFloat(4))
                            }
                            .WXMCardStyle(backgroundColor: Color.pink,
                                          insideHorizontalPadding: 0.0,
                                          insideVerticalPadding: 0.0,
                                          cornerRadius: CGFloat(4))
                            HStack(spacing: CGFloat(8.0)) {
                                Text(FontIcon.hexagon.rawValue)
                                    .font(.fontAwesome(font: .FAPro, size: 10.0))
                                    .foregroundColor(Color(colorEnum: .text))

                                Text("address")
                                    .font(.system(size: CGFloat(10.0)))
                                    .foregroundColor(Color(colorEnum: .text))
                                    .lineLimit(1)
                            }
                            .WXMCardStyle(backgroundColor: Color(colorEnum: .blueTint),
                                          insideHorizontalPadding: CGFloat(8),
                                          insideVerticalPadding: CGFloat(4),
                                      cornerRadius: CGFloat(4))
                        }
                    }
                    .background(Color.green)
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
