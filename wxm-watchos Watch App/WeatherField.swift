//
//  WeatherField.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import Foundation

public enum WeatherField: String, CaseIterable, Codable {
    case temperature
    case feelsLike = "feels_like"
    case humidity
    case wind = "wind_speed"
    case windDirection = "wind_direction"
    case precipitation = "precipitation"
    case precipitationProbability = "precipitation_probability"
    case dailyPrecipitation = "precipitation_accumulated"
    case windGust = "wind_gust"
    case pressure
    case solarRadiation = "solar_radiation"
    case illuminance
    case dewPoint = "dew_point"
    case uv
}
