//
//  ClockDiscovery.swift
//  LYWSD02 Clock Sync (iOS)
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation

protocol BluetoothClockDiscoveryDelegate {
    /// Called when a new supported clock device has been found.
    ///
    /// - Parameters:
    ///   - clock: The newly discovered clock device
    func onDeviceFound(_ clock: any Clock) -> Void

    /// Called when a supported clock device is lost.
    ///
    /// - Parameters:
    ///   - clock: The clock device that was lost
    func onDeviceLost(_ clock: any Clock) -> Void

    /// Called when a supported clock device was connected.
    ///
    /// - Parameters:
    ///   - clock: The clock device that was connected
    func onDeviceConnected(_ clock: any Clock) -> Void

    /// Called when a supported clock device was disconnected.
    ///
    /// - Parameters:
    ///   - clock: The clock device that was disconnected
    func onDeviceDisconnected(_ clock: any Clock) -> Void
    
    func onDiscoveryStarted() -> Void
    func onDiscoveryStopped() -> Void
}

protocol BluetoothClockClient {
    var delegate: BluetoothClockDiscoveryDelegate? { get set }

    func startScan() -> Void

    func stopScan() -> Void

    /// Open a connection to the given clock object
    ///
    /// - Throws: `ConnectionError`: When no connection could be made to the given clock
    func connect(to clock: any Clock) throws -> Void

    /// Open a connection to the given clock object
    ///
    /// - Throws: `ConnectionError`: When the connection with the given clock could not be broken
    func disconnect(from clock: any Clock) throws -> Void
}

struct MockBluetoothClockClient: BluetoothClockClient {
    var clock: any Clock = MockClock()
    var delegate: BluetoothClockDiscoveryDelegate?
    
    func startScan() {
        delegate?.onDiscoveryStarted()
        delegate?.onDeviceFound(clock)
    }
    
    func stopScan() {
        delegate?.onDiscoveryStopped()
        delegate?.onDeviceLost(clock)
    }
    
    func connect(to clock: any Clock) throws {
        delegate?.onDeviceConnected(clock)
    }
    
    func disconnect(from clock: any Clock) throws {
        delegate?.onDeviceDisconnected(clock)
    }
    
    
}
