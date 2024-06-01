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
    @Published var devices = [NetworkDevicesResponse]()
    
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
                    WeatherStationCellView(device: device)
                }
            }
            .navigationTitle("Fav stations")
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
    let viewModel = WeatherStationsHomeViewModel()
    viewModel.devices = NetworkDevicesResponse.dummyData
    return WeatherStationsHomeView(viewModel: viewModel)
}
