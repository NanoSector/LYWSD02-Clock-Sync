////
////  BluetoothClient.swift
////  LYWSD02 Clock Sync
////
////  Created by Rick Kerkhof on 05/11/2021.
////
//
//import CoreBluetooth
//import Foundation
//
//class BLEClient: NSObject, ObservableObject, CBCentralManagerDelegate {
//    @Published public var discoveredPeripherals: [BLEDeviceModel] = []
//    
//    // detached from the manager because this lets us use a published property
//    @Published var scanning: Bool = false
//    
//    private var manager: CBCentralManager!
//    
//    override required init() {
//        super.init()
//        self.manager = CBCentralManager(delegate: self, queue: nil)
//    }
//    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .unknown:
//            print("central.state is .unknown")
//        case .resetting:
//            print("central.state is .resetting")
//        case .unsupported:
//            print("central.state is .unsupported")
//        case .unauthorized:
//            print("central.state is .unauthorized")
//        case .poweredOff:
//            print("central.state is .poweredOff")
//            stopScan()
//        case .poweredOn:
//            print("central.state is .poweredOn")
//            triggerScan()
//        @unknown default:
//            print("Unknown state")
//        }
//    }
//    
//    func triggerScan() {
//        discoveredPeripherals.removeAll()
////        manager.scanForPeripherals(withServices: [CBUUID(string: LYWSD02UUID.Service.Unknown1.rawValue), CBUUID(string: LYWSD02UUID.Service.Unknown2.rawValue)], options: nil)
//        scanning = true
//    }
//    
//    func stopScan() {
//        manager.stopScan()
//        scanning = false
//    }
//    
//    func connect(to model: BLEDeviceModel) {
//        if model.peripheral.state == .connected {
//            return
//        }
//        
//        manager.connect(model.peripheral, options: nil)
//    }
//    
//    func disconnect(_ model: BLEDeviceModel) {
//        if model.peripheral.state == .disconnected {
//            return
//        }
//        
//        manager.cancelPeripheralConnection(model.peripheral)
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
//                        advertisementData: [String: Any], rssi RSSI: NSNumber)
//    {
//        print(peripheral)
//        if !discoveredPeripherals.contains(where: { peripheral.identifier == $0.peripheral.identifier }) {
//            discoveredPeripherals.append(BLEDeviceModel(peripheral))
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("Connected! Discovering services")
//        peripheral.discoverServices(nil)
//    }
//}
