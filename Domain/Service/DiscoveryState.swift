//
//  DiscoveryState.swift
//  LYWSD02 Clock Sync
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation

@Observable class DiscoveryState: BluetoothClockDiscoveryDelegate {
    var discovered: [any Clock] = []
    var discovering: Bool = false
    
    init() {}
    
    init(discovered: [any Clock], discovering: Bool) {
        self.discovered = discovered
        self.discovering = discovering
    }
    
    func onDeviceFound(_ clock: any Clock) {
        if (!discovered.contains(where: { $0.id == clock.id })) {
            // TODO: Remove hack
            if let xiaomi = clock as? XiaomiLYWSD02 {
                xiaomi.getPeripheral().delegate = xiaomi
            }
            discovered.append(clock)
        }
    }
    
    func onDeviceLost(_ clock: any Clock) {
        discovered.removeAll(where: { $0.id == clock.id })
    }
    
    func onDiscoveryStarted() {
        self.discovering = true
    }
    
    func onDiscoveryStopped() {
        self.discovering = false
    }
}
