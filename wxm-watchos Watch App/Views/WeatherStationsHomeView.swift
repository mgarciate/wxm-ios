//
//  WeatherStationsHomeView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 19/5/24.
//

import SwiftUI

protocol WeatherStationsHomeViewModelProtocol: ObservableObject {
    var isLoading: Bool { get set }
    var devices: [NetworkDevicesResponse] { get set }
    
    func fetchData() async
}

final class WeatherStationsHomeViewModel: WeatherStationsHomeViewModelProtocol {
    @Published var isLoading = true
    @Published var devices = [NetworkDevicesResponse]()
    
    init() {}
    
    func fetchData() async {
        isLoading = true
        do {
            #if DEBUG
            print("Run devices endpoint")
            #endif
            let devices = try await NetworkService<[NetworkDevicesResponse]>().get(endpoint: .myDevices)
            await MainActor.run {
                self.devices = devices
                isLoading = false
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
    @ObservedObject var locationService = LocationService()
    @State private var showNearDevices = false
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                NavigationStack {
                    ZStack {
                        List(viewModel.devices) { device in
                            NavigationLink {
                                StationDetailsContainerView(device: device)
                            } label: {
                                WeatherStationCellView(device: device)
                                    .listRowBackground(Color(colorEnum: .darkestBlue))
                            }
                        }
                        .navigationTitle("Fav. stations")
                        .listStyle(.carousel)
                        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    NavigationLink(destination: WeatherStationsNearView(viewModel: WeatherStationsNearViewModel(latitude: locationService.latitude, longitude: locationService.longitude)), isActive: $locationService.locationReceived) {
                                        EmptyView()
                                    }
                                    Button(action: {
                                        locationService.requestLocation()
                                    }) {
                                        Image(.detectLocation)
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                            .padding()
                                            .background(Color(.bg))
                                            .foregroundColor(Color(.top))
                                            .clipShape(Circle())
                                    }
                                }
                                .frame(width: 40, height: 40)
                            }
                        }
                    }
                }
                .background {
                    Color(colorEnum: .darkBg)
                }
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    let viewModel = WeatherStationsHomeViewModel()
    viewModel.devices = NetworkDevicesResponse.dummyData
    viewModel.isLoading = false
    return WeatherStationsHomeView(viewModel: viewModel)
}
