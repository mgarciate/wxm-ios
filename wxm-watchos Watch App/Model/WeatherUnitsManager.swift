//
//  WeatherUnitsManager.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import Foundation

class WeatherUnitsManager: ObservableObject {

    static let `default`: WeatherUnitsManager =  {
        let manager = WeatherUnitsManager()
        
        return manager
    }()

    var temperatureUnit: TemperatureUnitsEnum {
        get {
            getTemperatureMetricEnum()
        }
    }

    var precipitationUnit: PrecipitationUnitsEnum {
        get {
            getPrecipitationMetricEnum()
        }
    }

    var windSpeedUnit: WindSpeedUnitsEnum {
        get {
            getWindSpeedMetricEnum()
        }
    }

    var windDirectionUnit: WindDirectionUnitsEnum {
        get {
            getWindDirectionMetricEnum()
        }
    }

    var pressureUnit: PressureUnitsEnum {
        get {
            getPressureMetricEnum()
        }
    }

    // MARK: Temperature userDefaults

    private func getTemperatureMetricEnum() -> TemperatureUnitsEnum {
        return .celsius
    }

    // MARK: Percipitation userDefaults

    private func getPrecipitationMetricEnum() -> PrecipitationUnitsEnum {
        return .millimeters
    }

    // MARK: Wind Speed userDefaults

    private func getWindSpeedMetricEnum() -> WindSpeedUnitsEnum {
        return .metersPerSecond
    }

    // MARK: Wind Direction userDefaults

    private func getWindDirectionMetricEnum() -> WindDirectionUnitsEnum {
        return .cardinal
    }

    // MARK: Pressure userDefaults

    private func getPressureMetricEnum() -> PressureUnitsEnum {
        return .hectopascal
    }
}
