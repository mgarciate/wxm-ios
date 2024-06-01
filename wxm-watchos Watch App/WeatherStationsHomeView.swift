//
//  WeatherStationsHomeView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 19/5/24.
//

import SwiftUI

protocol WeatherStationsHomeViewModelProtocol: ObservableObject {
    var devices: [NetworkDevicesResponse] { get set }
    
    func fetchData() async
}

final class WeatherStationsHomeViewModel: WeatherStationsHomeViewModelProtocol {
    @Published var devices: [NetworkDevicesResponse] = NetworkDevicesResponse.dummyData
    
    init() {}
    
    func fetchData() async {
        do {
            #if DEBUG
            print("Run devices endpoint")
            #endif
            let devices = try await NetworkService<[NetworkDevicesResponse]>().get(endpoint: .myDevices)
            await MainActor.run {
                self.devices = devices
            }
        } catch {
            #if DEBUG
            print("Error", error)
            #endif
        }
    }
}

struct WeatherStationsHomeView<ViewModel>: View where ViewModel: WeatherStationsHomeViewModelProtocol {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.devices) { device in
                NavigationLink {
                    StationDetailsContainerView(device: device)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(device.address ?? "no address")
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

                                    Text(device.attributes.lastActiveAt?.lastActiveTime() ?? "no data")
                                        .font(.system(size: CGFloat(10.0)))
                                        .foregroundColor(Color.green)
                                        .padding(.trailing, CGFloat(4))
                                }
                                .WXMCardStyle(backgroundColor: Color.pink,
                                              insideHorizontalPadding: 0.0,
                                              insideVerticalPadding: 0.0,
                                              cornerRadius: CGFloat(4))
//                                HStack(spacing: CGFloat(8.0)) {
//                                    Text(FontIcon.hexagon.rawValue)
//                                        .font(.fontAwesome(font: .FAPro, size: 10.0))
//                                        .foregroundColor(Color(colorEnum: .text))
//
//                                    Text("address")
//                                        .font(.system(size: CGFloat(10.0)))
//                                        .foregroundColor(Color(colorEnum: .text))
//                                        .lineLimit(1)
//                                }
//                                .WXMCardStyle(backgroundColor: Color(colorEnum: .blueTint),
//                                              insideHorizontalPadding: CGFloat(8),
//                                              insideVerticalPadding: CGFloat(4),
//                                          cornerRadius: CGFloat(4))
                            }
                        }
                        if let temperature = device.currentWeather?.temperature {
                            Text("\(Int(round(temperature)))º")
                        } else {
                            Text("-º")
                        }
                    }
                    .background(Color.green)
                }
            }
            .navigationTitle("Select a Station")
            .listStyle(.carousel)
        }
        .background {
            Color(colorEnum: .top)
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    WeatherStationsHomeView(viewModel: WeatherStationsHomeViewModel())
}
