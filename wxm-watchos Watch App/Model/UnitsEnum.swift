//
//  UnitsEnum.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import Foundation

public protocol UnitsProtocol {
    var key: String { get }
    var value: String { get }
}

public enum TemperatureUnitsEnum: String, CaseIterable, UnitsProtocol {
    case celsius, fahrenheit

    public var key: String {
        UserDefaults.WeatherUnitKey.temperature.rawValue
    }

    public var value: String {
        return rawValue
    }
}

public enum PrecipitationUnitsEnum: String, CaseIterable, UnitsProtocol {
    case millimeters, inches

    public var key: String {
        UserDefaults.WeatherUnitKey.precipitation.rawValue
    }

    public var value: String {
        rawValue
    }
}

public enum WindSpeedUnitsEnum: String, CaseIterable, UnitsProtocol {
    case kilometersPerHour, milesPerHour, metersPerSecond, knots, beaufort

    public var key: String {
        UserDefaults.WeatherUnitKey.windSpeed.rawValue
    }

    public var value: String {
        rawValue
    }
}

public enum WindDirectionUnitsEnum: String, CaseIterable, UnitsProtocol {
    case cardinal, degrees

    public var key: String {
        UserDefaults.WeatherUnitKey.windDirection.rawValue
    }

    public var value: String {
        rawValue
    }
}

public enum PressureUnitsEnum: String, CaseIterable, UnitsProtocol {
    case hectopascal, inchOfMercury

    public var key: String {
        UserDefaults.WeatherUnitKey.pressure.rawValue
    }

    public var value: String {
        rawValue
    }
}
