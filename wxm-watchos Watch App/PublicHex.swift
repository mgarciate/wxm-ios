//
//  PublicHex.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import Foundation

public struct PublicHex: Codable {
    public var index: String = ""
    public var deviceCount: Int? = nil
    public var center: HexLocation = .init()
    public var polygon: [HexLocation] = []

    enum CodingKeys: String, CodingKey {
        case index
        case deviceCount = "device_count"
        case center
        case polygon
    }
}

public struct HexLocation: Codable {
    public var lat: Double = 0.0
    public var lon: Double = 0.0
}
