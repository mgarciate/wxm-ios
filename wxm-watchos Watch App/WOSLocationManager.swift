//
//  WOSLocationManager.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import Foundation
import CoreLocation

struct WOSLocationManager {
    // Function to check if a point is inside a polygon using Ray Casting algorithm
    static func isPointInPolygon(point: LocationCoordinates, polygon: [LocationCoordinates]) -> Bool {
        var isInside = false
        let n = polygon.count
        var j = n - 1
        
        for i in 0..<n {
            let vertex1 = polygon[i]
            let vertex2 = polygon[j]
            
            if (vertex1.lon > point.lon) != (vertex2.lon > point.lon),
               point.lat < (vertex2.lat - vertex1.lat) * (point.lon - vertex1.lon) / (vertex2.lon - vertex1.lon) + vertex1.lat {
                isInside = !isInside
            }
            j = i
        }
        return isInside
    }
}

