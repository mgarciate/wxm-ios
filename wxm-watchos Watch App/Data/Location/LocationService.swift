//
//  LocationService.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 2/6/24.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationService = CLLocationManager()
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var locationReceived = false
    
    override init() {
        super.init()
        self.locationService.delegate = self
    }
    
    func requestLocation() {
        self.locationService.requestWhenInUseAuthorization()
        self.locationService.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.locationReceived = true
        self.locationService.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
