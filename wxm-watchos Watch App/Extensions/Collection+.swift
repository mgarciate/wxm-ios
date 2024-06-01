//
//  Collection+.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
