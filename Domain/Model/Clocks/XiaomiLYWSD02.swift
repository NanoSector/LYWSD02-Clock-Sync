//
//  XiaomiLYWSD02.swift
//  LYWSD02 Clock Sync (iOS)
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import CoreBluetooth
import Foundation

@Observable class XiaomiLYWSD02: NSObject, Clock, CBPeripheralDelegate {
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
    
    typealias State = XiaomiLYWSD02State
    
    init(peripheral: CBPeripheral) {
        print("Init called with peripheral \(peripheral.identifier)")
        self.peripheral = peripheral
        super.init()
    }
    
    private var peripheral: CBPeripheral
    var lastState: XiaomiLYWSD02State? = nil
    
    var id: UUID { return peripheral.identifier }
    var friendlyName: String { return peripheral.name ?? "Unnamed Xiaomi LYWSD02" }
    
    var kind: ClockModel {
        return ClockModel.XiaomiLYWSD02
    }
    
    private var lastBatteryLevel: Int? = nil
    private var lastHumidity: Int? = nil
    private var lastTemperature: Double? = nil
    private var lastTime: Date? = nil
    
    func onConnected() {
    }
    
    func getPeripheral() -> CBPeripheral {
        return self.peripheral
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Wrote value")
        guard error == nil else {
            print("Something went wrong while writing a value!")
            print(error.debugDescription)
            return
        }
        
        sync()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered service")
        if let service = peripheral.services?.first(where: { $0.uuid == CBUUID(string: Service.Data.rawValue) }) {
            print("Found service which should contain time data. Discovering characteristics...")
                
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Discovered characteristics")
        
        if let timeCharacteristic = service.characteristics?.first(where: { $0.uuid == CBUUID(string: Characteristic.Time.rawValue) }) {
            print("Found time data characteristics, subscribing.")
            peripheral.readValue(for: timeCharacteristic)
        }
            
        if let batteryCharacteristic = service.characteristics?.first(where: { $0.uuid == CBUUID(string: Characteristic.Battery.rawValue) }) {
            print("Found battery data characteristics, subscribing.")
            peripheral.readValue(for: batteryCharacteristic)
        }
        
        if let characteristic = service.characteristics?.first(where: { $0.uuid == CBUUID(string: Characteristic.SensorData.rawValue) }) {
            print("Found sensor data characteristics, subscribing.")
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Updated value")
        switch characteristic.uuid {
        case CBUUID(string: Characteristic.Time.rawValue):
            guard let data = characteristic.value else {
                print("Got time characteristic update but no value...")
                return
            }
            
            print("Got time")
            let unpacked = try! unpack("<Ib", data)
            lastTime = Date(timeIntervalSince1970: TimeInterval(unpacked[0] as! Int))
        case CBUUID(string: Characteristic.Battery.rawValue):
            guard let data = characteristic.value, let firstByte = data.first else {
                print("Got battery characteristic update but no value...")
                return
            }
            
            print("Got battery")
            lastBatteryLevel = Int(firstByte)
        case CBUUID(string: Characteristic.SensorData.rawValue):
            guard let data = characteristic.value else {
                print("Got sensor data characteristic update but no value...")
                return
            }
            
            if let unpacked = try? unpack("<hB", data) {
                print("Got sensors")
                lastTemperature = Double(unpacked[0] as! Int) / 100
                lastHumidity = unpacked[1] as? Int
            }
        default:
            print("Unknown characteristic was updated")
        }
        
        if let time = lastTime, let battery = lastBatteryLevel, let humidity = lastHumidity, let temperature = lastTemperature {
            print("Complete; setting state")
            lastState = XiaomiLYWSD02State(batteryLevel: battery,
                                           humidity: humidity, temperatureUnit: .celsius, temperature: Float(temperature), time: Time(date: time, timezoneOffset: 1))
        }
    }
}

struct XiaomiLYWSD02State: ClockState, BatteryState, HygrometerState, ThermometerState {
    var batteryLevel: Int
    
    var humidity: Int
    
    var temperatureUnit: UnitTemperature
    
    var temperature: Float
    
    var time: Time
}
