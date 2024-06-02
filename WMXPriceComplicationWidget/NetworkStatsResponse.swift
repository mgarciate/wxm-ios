//
//  NetworkStatsResponse.swift
//  DomainLayer
//
//  Created by Pantelis Giazitsis on 12/6/23.
//

import Foundation

public struct NetworkStatsResponse: Codable {
    public let weatherStations: NetworkWeatherStations?

    enum CodingKeys: String ,CodingKey {
        case weatherStations = "weather_stations"
    }
}

public struct NetworkWeatherStations: Codable {
    public let onboarded: NetworkStationsStats?
    public let claimed: NetworkStationsStats?
    public let active: NetworkStationsStats?
}

public struct NetworkStationsStats: Codable {
    public let total: Int?
    public let details: [NetworkStationsStatsDetails]?
}

public struct NetworkStationsStatsDetails: Codable {
    public let model: String?
//    public let connectivity: Connectivity? // Unnecessary here
    public let amount: Int?
    public let percentage: Float?
    public let url: String?
}
