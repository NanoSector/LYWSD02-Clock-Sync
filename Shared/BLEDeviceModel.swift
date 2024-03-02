////
////  BLEDevicePeripheral.swift
////  LYWSD02 Clock Sync (macOS)
////
////  Created by Rick Kerkhof on 06/11/2021.
////
//
//import Foundation
//import CoreBluetooth
//
//class BLEDeviceModel: NSObject, ObservableObject, CBPeripheralDelegate {
//    @Published private(set) var hasTimeSupport = false
//    @Published private(set) var hasBatterySupport = false
//    @Published private(set) var hasTemperatureSupport = false
//    @Published private(set) var hasHumiditySupport = false
//    
//    @Published private(set) var batteryPercentage: Int? = nil
//    @Published private(set) var currentTime: Date? = nil
//    @Published private(set) var currentTemperature: Double? = nil
//    @Published private(set) var currentHumidity: Int? = nil
//    
//    @Published private(set) var name: String
//    
//    private var _peripheral: CBPeripheral
//    
//    // MARK: Wrappers for CBPeripheral fields.
//    var identifier: String { peripheral.identifier.uuidString }
//    
//    // get-only wrapper
//    var peripheral: CBPeripheral { self._peripheral }
//    
//    required init(_ peripheral: CBPeripheral) {
//        self._peripheral = peripheral
//        self.name = peripheral.name ?? "Unknown name"
//        super.init()
//        peripheral.delegate = self
//    }
//    
//    func sync() {
//        batteryPercentage = nil
//        currentTime = nil
//        
//        guard let service = peripheral.services?.first(where: { $0.uuid == LYWSD02UUID.Service.Data.rawValue.cbuuid! }) else {
//            return
//        }
//        
//        if (hasTimeSupport) {
//            if let timeCharacteristic = service.characteristics?.first(where: { $0.uuid == LYWSD02UUID.Characteristic.Time.rawValue.cbuuid! }) {
//                peripheral.readValue(for: timeCharacteristic)
//            }
//        }
//        
//        if (hasBatterySupport) {
//            if let batteryCharacteristic = service.characteristics?.first(where: { $0.uuid == LYWSD02UUID.Characteristic.Battery.rawValue.cbuuid! }) {
//                peripheral.readValue(for: batteryCharacteristic)
//            }
//        }
//    }
//    
//    func syncTime(target: Date) {
//        if (!hasTimeSupport) {
//            print("Syncing time without time support. Dropping.")
//            return
//        }
//        
//        guard let service = peripheral.services?.first(where: { $0.uuid == LYWSD02UUID.Service.Data.rawValue.cbuuid! }) else {
//            return
//        }
//        
//        guard let timeCharacteristic = service.characteristics?.first(where: { $0.uuid == LYWSD02UUID.Characteristic.Time.rawValue.cbuuid! }) else {
//            return
//        }
//        
//        let timezone = TimeZone.current
//        let time = Time(timestamp: Int(target.timeIntervalSince1970), timezoneOffset: timezone.secondsFromGMT() / 3600) // todo make timezone configurable
//        
//        peripheral.writeValue(time.data(), for: timeCharacteristic, type: .withResponse)
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard error == nil else {
//            print("Something went wrong while writing a value!")
//            print(error.debugDescription)
//            return
//        }
//        
//        sync()
//    }
//    
//    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
//        self.name = peripheral.name ?? "Unknown name"
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        for service in peripheral.services! {
//            if service.uuid == CBUUID(nsuuid: UUID(uuidString: LYWSD02UUID.Service.Data.rawValue)!) {
//                print("Found service which should contain time data. Discovering characteristics...")
//                
//                peripheral.discoverCharacteristics(nil, for: service)
//            }
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        print("Got characteristics!")
//        
//        for characteristic in service.characteristics! {
//            if characteristic.uuid == LYWSD02UUID.Characteristic.Time.rawValue.cbuuid! {
//                print("Found time characteristic in service. Time support is available.")
//                hasTimeSupport = true
//            }
//            
//            if characteristic.uuid == LYWSD02UUID.Characteristic.Battery.rawValue.cbuuid! {
//                print("Found battery characteristic in service. Battery support is available.")
//                hasBatterySupport = true
//            }
//            
//            if characteristic.uuid == LYWSD02UUID.Characteristic.SensorData.rawValue.cbuuid! {
//                print("Found sensor data characteristics, subscribing.")
//                peripheral.setNotifyValue(true, for: characteristic)
//                hasTemperatureSupport = true
//                hasHumiditySupport = true
//            }
//        }
//        
//        sync()
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        switch characteristic.uuid {
//        case LYWSD02UUID.Characteristic.Time.rawValue.cbuuid!:
//            guard let data = characteristic.value else {
//                print("Got time characteristic update but no value...")
//                return
//            }
//            
//            let unpacked = try! unpack("<Ib", data)
//            let date = Date(timeIntervalSince1970: TimeInterval(unpacked[0] as! Int))
//            currentTime = date
//            break
//        case LYWSD02UUID.Characteristic.Battery.rawValue.cbuuid!:
//            guard let data = characteristic.value, let firstByte = data.first else {
//                print("Got battery characteristic update but no value...")
//                return
//            }
//            
//            batteryPercentage = Int(firstByte)
//            break
//        case LYWSD02UUID.Characteristic.SensorData.rawValue.cbuuid!:
//            guard let data = characteristic.value else {
//                print("Got sensor data characteristic update but no value...")
//                return
//            }
//            
//            if let unpacked = try? unpack("<hB", data) {
//                currentTemperature = Double(unpacked[0] as! Int) / 100
//                currentHumidity = unpacked[1] as? Int
//            }
//            break
//        default:
//            print("Unknown characteristic was updated")
//        }
//    }
//}
