//
//  LYWSD02_Clock_SyncApp.swift
//  Shared
//
//  Created by Rick Kerkhof on 05/11/2021.
//

import SwiftUI

@main
struct Application: App {
    @State private var state = DiscoveryState()
    
    var body: some Scene {
        WindowGroup {
            ClockListView(bluetoothClient: CoreBluetoothClockClient(delegate: self.state))
                .environment(state)
        }
    }
}
