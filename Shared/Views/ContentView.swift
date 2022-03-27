//
//  ContentView.swift
//  Shared
//
//  Created by Rick Kerkhof on 05/11/2021.
//

import CoreBluetooth
import SwiftUI

struct ContentView: View {
    @StateObject private var bleClient = BLEClient()

    var body: some View {
        NavigationView {
            List {
                ForEach(bleClient.discoveredPeripherals, id: \.identifier) { peripheral in
                    NavigationLink(destination: DeviceView(peripheral: peripheral)) {
                        VStack(alignment: .leading) {
                            Text(peripheral.name)
                            Text(peripheral.identifier).font(.footnote)
                        }
                    }
                }
            }
            .toolbar {
                Button(action: {
                    if bleClient.scanning {
                        bleClient.stopScan()
                    } else {
                        bleClient.triggerScan()
                    }
                }) {
                    Image(systemName: bleClient.scanning ? "stop.circle.fill" : "arrow.clockwise")
                }
            }.navigationTitle("Discovered Devices")
        }.environmentObject(bleClient)
            .onDisappear {
                bleClient.stopScan()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
