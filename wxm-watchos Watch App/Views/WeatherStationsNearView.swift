//
//  WeatherStationsNearView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import SwiftUI

protocol WeatherStationsNearViewModelProtocol: ObservableObject {
    var isLoading: Bool { get set }
    var devices: [NetworkDevicesResponse] { get set }
    
    func fetchData() async
}

final class WeatherStationsNearViewModel: WeatherStationsNearViewModelProtocol {
    @Published var isLoading = true
    @Published var devices = [NetworkDevicesResponse]()
    
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
        await MainActor.run {
            isLoading = true
        }
        do {
            print("Start call")
            let cells = try await NetworkService<[PublicHex]>().get(endpoint: .cells)
            
            let location = LocationCoordinates(lat: 45.788953151906384, long: 24.02408932624046)
            for cell in cells {
                var hexagon: [LocationCoordinates] = []
                cell.polygon.forEach { point in
                    hexagon.append(LocationCoordinates(lat: point.lat, long: point.lon))
                }
                let isInside = WOSLocationManager.isPointInPolygon(point: location, polygon: hexagon)
                if isInside {
                    print("Is the location inside the hexagon? \(isInside)")
                    print("Cell \(cell)")
                    var devicesByCell = try await NetworkService<[NetworkDevicesResponse]>().get(endpoint: .devicesByCell(cellId: cell.index))
                    for i in devicesByCell.indices {
                        devicesByCell[i].location = LocationCoordinates(lat: cell.center.lat, long: cell.center.lon)
                        devicesByCell[i].attributes.lastActiveAt = devicesByCell[i].lastActiveAt
                        devicesByCell[i].attributes.isActive = devicesByCell[i].isActive
                    }
                    let devices = devicesByCell
                    await MainActor.run {
                        self.devices.append(contentsOf: devices)
                        isLoading = false
                    }
                }
            }
            print("End with \(cells.count)")
        } catch {
            #if DEBUG
            print("Error", error)
            #endif
        }
    }
}

struct WeatherStationsNearView<ViewModel>: View where ViewModel: WeatherStationsNearViewModelProtocol {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                NavigationStack {
                    List(viewModel.devices) { device in
                        NavigationLink {
                            StationDetailsContainerView(device: device)
                        } label: {
                            WeatherStationCellView(device: device)
                        }
                    }
                    .navigationTitle("Near stations")
                    .listStyle(.carousel)
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
    let viewModel = WeatherStationsNearViewModel()
    viewModel.devices = NetworkDevicesResponse.dummyData
    return WeatherStationsNearView(viewModel: viewModel)
}
