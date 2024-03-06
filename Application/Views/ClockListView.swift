//
//  ContentView.swift
//  Shared
//
//  Created by Rick Kerkhof on 05/11/2021.
//

import CoreBluetooth
import SwiftUI

struct ClockListView: View {
    @Environment(DiscoveryState.self) private var state: DiscoveryState
    var bluetoothClient: BluetoothClockClient

    func toggleDiscovery() {
        if state.discovering {
            bluetoothClient.stopScan()
        } else {
            bluetoothClient.startScan()
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(state.discovered, id: \.id) { clock in
                    NavigationLink(
                        destination: ClockDetailsView(
                            clock: clock,
                            bluetoothClient: bluetoothClient
                        )
                    ) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "deskclock.fill")
                            VStack(alignment: .leading) {
                                Text(clock.friendlyName)
                                Text("\(clock.id)").font(.footnote)
                            }
                        }
                    }
                }

                if !state.discovered.isEmpty && state.discovering {
                    HStack(alignment: .center, spacing: 10) {
                        ProgressView()
                        Text("Still looking for more clocks...")
                    }
                }
            }
            .overlay {
                if state.discovered.isEmpty {
                    if state.discovering {
                        ProgressView {
                            Text("Looking for clocks...")
                        }
                    } else {
                        ContentUnavailableView {
                            Label("No clocks discovered", systemImage: "clock.badge.questionmark")

                            Button("Start discovering", action: toggleDiscovery)
                                .buttonStyle(.bordered)
                        }
                    }
                }
            }
            .toolbar {
                Button(action: {
                    toggleDiscovery()
                }) {
                    Image(systemName: state.discovering ? "stop.circle.fill" : "arrow.clockwise")
                }
            }.navigationTitle("Clocks")
        }
        .onDisappear {
            bluetoothClient.stopScan()
        }
    }
}

#Preview("Empty state, not discovering") {
    let state = DiscoveryState(
        discovered: [],
        discovering: false
    )

    return ClockListView(
        bluetoothClient: MockBluetoothClockClient(delegate: state)
    ).environment(state)
}

#Preview("Empty state, discovering") {
    let state = DiscoveryState(
        discovered: [],
        discovering: true
    )

    return ClockListView(
        bluetoothClient: MockBluetoothClockClient(delegate: state)
    ).environment(state)
}

#Preview("Non-empty state, not discovering") {
    let state = DiscoveryState(
        discovered: [MockClock()],
        discovering: false
    )

    return ClockListView(
        bluetoothClient: MockBluetoothClockClient(delegate: state)
    ).environment(state)
}

#Preview("Non-empty state, discovering") {
    let state = DiscoveryState(
        discovered: [MockClock()],
        discovering: true
    )

    return ClockListView(
        bluetoothClient: MockBluetoothClockClient(delegate: state)
    ).environment(state)
}
