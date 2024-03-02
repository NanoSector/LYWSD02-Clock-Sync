//
//  MockClock.swift
//  LYWSD02 Clock Sync (iOS)
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation

struct MockClock : Clock, BatteryPowered, Hygrometer, Thermometer {
    var id: UUID = UUID()
    var friendlyName: String = "Mock Clock"
    
    var batteryLevel: Int = 69
    
    var humidity: Int = 42
    
    var temperatureUnit: UnitTemperature = UnitTemperature.celsius
    
    var temperature: Float = 21.0
    
    var kind: ClockModel = ClockModel.Mock
    
    var time: Time = Time()
}
