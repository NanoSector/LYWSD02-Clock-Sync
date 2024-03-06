//
//  MockClock.swift
//  LYWSD02 Clock Sync (iOS)
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation

@Observable class MockClock: Clock {
    typealias State = MockClockState

    var id: UUID = .init()
    var friendlyName: String = "Mock Clock"
    var kind: ClockModel = .Mock
    var lastState: MockClockState? = MockClockState()
}

struct MockClockState: ClockState, BatteryState, HygrometerState, ThermometerState {
    var batteryLevel: Int = 69
    var humidity: Int = 42
    var temperatureUnit: UnitTemperature = .celsius
    var temperature: Float = 21.0
    var time: Time = .init()
}
