//
//  DiscoveryState.swift
//  LYWSD02 Clock Sync
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation

@Observable class DiscoveryState: BluetoothClockDiscoveryDelegate {
    var connected: (any Clock)? = nil
    var discovered: [any Clock] = []
    var discovering: Bool = false
    
    init() {}
    
    init(connected: (any Clock)? = nil, discovered: [any Clock], discovering: Bool) {
        self.connected = connected
        self.discovered = discovered
        self.discovering = discovering
    }
    
    func onDeviceFound(_ clock: any Clock) {
        if (!discovered.contains(where: { $0.id == clock.id })) {
            discovered.append(clock)
        }
    }
    
    func onDeviceLost(_ clock: any Clock) {
        discovered.removeAll(where: { $0.id == clock.id })
    }
    
    func onDeviceConnected(_ clock: any Clock) {
        self.connected = clock
    }
    
    func onDeviceDisconnected(_ clock: any Clock) {
        self.connected = nil
    }
    
    func onDiscoveryStarted() {
        self.discovering = true
    }
    
    func onDiscoveryStopped() {
        self.discovering = false
    }
}
