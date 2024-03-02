//
//  XiaomiLYWSD02.swift
//  LYWSD02 Clock Sync (iOS)
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import CoreBluetooth
import Foundation

struct XiaomiLYWSD02: Clock, BatteryPowered, Thermometer, Hygrometer {
    /// Based on the LYWSD02 Python library: https://github.com/h4/lywsd02/blob/master/lywsd02/client.py
    enum Service: String {
        case Unknown1 = "181A" // in advertisement
        case Unknown2 = "FEF5" // in advertisement
        case Data = "EBE0CCB0-7A0A-4B0C-8A1A-6FF2997DA3A6"
    }
    
    enum Characteristic: String {
        case Time = "EBE0CCB7-7A0A-4B0C-8A1A-6FF2997DA3A6" // 5 or 4 bytes, READ WRITE
        case Battery = "EBE0CCC4-7A0A-4B0C-8A1A-6FF2997DA3A6" // 1 byte, READ
        case SensorData = "EBE0CCC1-7A0A-4B0C-8A1A-6FF2997DA3A6" // 3 bytes, READ NOTIFY
    }
    
    private var peripheral: CBPeripheral
    
    var id: UUID { return peripheral.identifier }
    var friendlyName: String { return peripheral.name ?? "Unnamed Xiaomi LYWSD02" }
    
    var kind: ClockModel {
        return ClockModel.XiaomiLYWSD02
    }
    
    var time: Time
    
    var batteryLevel: Int
    
    var temperatureUnit: UnitTemperature
    
    var temperature: Float
    
    var humidity: Int
}
