//
//  BatteryPoweredClock.swift
//  LYWSD02 Clock Sync (iOS)
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation

protocol BatteryPowered {
    var batteryLevel: Int { get }
}
