//
//  DeviceView.swift
//  LYWSD02 Clock Sync (macOS)
//
//  Created by Rick Kerkhof on 05/11/2021.
//

import CoreBluetooth
import SwiftUI

struct ClockDetailsView: View {
    var clock: any Clock
    var bluetoothClient: BluetoothClockClient

    var body: some View {
        VStack {
            if let state = clock.lastState {
                XiaomiLYWSD02ClockView(clock: state)
            } else {
                ProgressView {
                    Text("Connecting...")
                }
            }

            List {
                Section {
                    HStack {
                        Text("ID")
                        Spacer()
                        Text("\(clock.id)")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }

                    HStack {
                        Text("Name")
                        Spacer()
                        Text(clock.friendlyName)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }

                    if let state = clock.lastState {
                        HStack {
                            Text("Time")
                            Spacer()
                            Text(state.time.date, style: .time)
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }

                        if let batteryPowered = state as? BatteryState {
                            HStack {
                                Text("Battery level")
                                Spacer()
                                Text("\(batteryPowered.batteryLevel)%")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }

                        if let thermometer = state as? ThermometerState {
                            HStack {
                                Text("Temperature")
                                Spacer()
                                Text("\(thermometer.temperature) °\(thermometer.temperatureUnit.asString())")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }

                        if let hygrometer = state as? HygrometerState {
                            HStack {
                                Text("Humidity")
                                Spacer()
                                Text("\(hygrometer.humidity)%")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }
                    }
                } header: {
                    Text("Properties")
                }
            }
        }
        .toolbar {
            Button(action: {
//                peripheral.sync()
            }) {
                Image(systemName: "arrow.clockwise")
                Text("Sync")
            }
        }
        .onAppear {
            do {
                try bluetoothClient.connect(to: clock)
            } catch {
                print(error)
            }
        }
        // .onDisappear {
        //    bleClient.disconnect(peripheral)
        // }
        // .popover(isPresented: $isPopoverPresented) {
//            VStack {
//                HStack {
//                    DatePicker("", selection: $targetDate)
//                        .labelsHidden()
//
//                    Button {
//                        peripheral.syncTime(target: targetDate)
//                    } label: {
//                        Image(systemName: "clock.badge.checkmark")
//                        Text("Set this time")
//                    }
//                }.padding()
//                Button {
//                    peripheral.syncTime(target: Date())
//                } label: {
//                    Image(systemName: "clock.arrow.2.circlepath")
//                    Text("Sync with device")
//                }
//            }.padding()
//        }
        .navigationTitle(clock.friendlyName)
    }
}

#Preview("Mock clock") {
    ClockDetailsView(clock: MockClock(), bluetoothClient: MockBluetoothClockClient())
}
