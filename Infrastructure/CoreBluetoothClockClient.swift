//
//  CoreBluetoothClockClient.swift
//  Clock Sync
//
//  Created by Rick Kerkhof on 06/03/2024.
//

import CoreBluetooth
import Foundation

class CoreBluetoothClockClient: NSObject, BluetoothClockClient, CBCentralManagerDelegate {
    var delegate: BluetoothClockDiscoveryDelegate?
    private var manager: CBCentralManager!
    
    required init(delegate: BluetoothClockDiscoveryDelegate) {
        super.init()
        self.delegate = delegate
        self.manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
            stopScan()
        case .poweredOn:
            print("central.state is .poweredOn")
            startScan()
        @unknown default:
            print("Unknown state")
        }
    }
    
    func startScan() {
        manager.scanForPeripherals(
            withServices: [
                CBUUID(string: XiaomiLYWSD02.Service.Unknown1.rawValue),
                CBUUID(string: XiaomiLYWSD02.Service.Unknown2.rawValue)
            ],
            options: nil
        )
        delegate?.onDiscoveryStarted()
    }
    
    func stopScan() {
        manager.stopScan()
        delegate?.onDiscoveryStopped()
    }
    
    func connect(to clock: any Clock) throws {
        guard let model = clock as? XiaomiLYWSD02 else {
            return
        }
        
        if model.getPeripheral().state == .connected {
            return
        }
        
        manager.connect(model.getPeripheral(), options: nil)
    }
    
    func disconnect(from clock: any Clock) throws {
        guard let model = clock as? XiaomiLYWSD02 else {
            return
        }
        
        if model.getPeripheral().state == .disconnected {
            return
        }
        
        manager.cancelPeripheralConnection(model.getPeripheral())
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber)
    {
        
        // TODO: Check if we can make a clock object
        let clock = XiaomiLYWSD02(peripheral: peripheral)
        
        delegate?.onDeviceFound(clock)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected! Discovering services")
        peripheral.discoverServices(nil)
    }
}
