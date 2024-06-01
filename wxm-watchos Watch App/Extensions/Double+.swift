//
//  Double+.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
