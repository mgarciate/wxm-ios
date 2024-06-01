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
    
    init() {
        // TODO: Delete, just for testing
//        let hexagon: [LocationCoordinates] = [
//            LocationCoordinates(lat: 37.7749, long: -122.4194),
//            LocationCoordinates(lat: 37.7799, long: -122.4144),
//            LocationCoordinates(lat: 37.7849, long: -122.4194),
//            LocationCoordinates(lat: 37.7799, long: -122.4244),
//            LocationCoordinates(lat: 37.7749, long: -122.4294),
//            LocationCoordinates(lat: 37.7699, long: -122.4244)
//        ]
//
//        let location = LocationCoordinates(lat: 37.777, long: -122.422)
//
//        let isInside = WOSLocationManager.isPointInPolygon(point: location, polygon: hexagon)
//        print("Is the location inside the hexagon? \(isInside)")
    }
    
    func fetchData() async {
        do {
            #if DEBUG
            print("Run devices endpoint")
            #endif
            let devices = try await NetworkService<[NetworkDevicesResponse]>().get(endpoint: .myDevices)
            await MainActor.run {
                self.devices = devices
            }
            print("Start call")
            let cells = try await NetworkService<[PublicHex]>().get(endpoint: .cells)
            
            let location = LocationCoordinates(lat: 50.92412074211983, long: -1.3339991931905284)
            var count = 0
            cells.forEach { cell in
                var hexagon: [LocationCoordinates] = []
                cell.polygon.forEach { point in
                    hexagon.append(LocationCoordinates(lat: point.lat, long: point.lon))
                }
                let isInside = WOSLocationManager.isPointInPolygon(point: location, polygon: hexagon)
                if isInside {
                    print("Is the location inside the hexagon? \(isInside)")
                    print("Cell \(cell)")
                }
                count += 1
            }
            print("End with \(cells.count) - \(count)")
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
