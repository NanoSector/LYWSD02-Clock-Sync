//
//  Thermometer.swift
//  LYWSD02 Clock Sync (iOS)
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation

protocol ThermometerState {
    var temperatureUnit: UnitTemperature { get }
    var temperature: Float { get }
}

extension UnitTemperature {
    func asString() -> String {
        switch self {
        case .celsius:
            return "C"
        case .fahrenheit:
            return "F"
        default:
            return "K"
        }
    }
}
