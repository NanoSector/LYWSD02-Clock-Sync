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

    var body: some View {
        VStack {
            XiaomiLYWSD02ClockView(clock: clock)

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
                    
                    HStack {
                        Text("Time")
                        Spacer()
                        Text(clock.time.date, style: .time)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    
                    if let batteryPowered = clock as? BatteryPowered {
                        HStack {
                            Text("Battery level")
                            Spacer()
                            Text("\(batteryPowered.batteryLevel)%")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                    }
                    
                    if let thermometer = clock as? Thermometer {
                        HStack {
                            Text("Temperature")
                            Spacer()
                            Text("\(thermometer.temperature) °\(thermometer.temperatureUnit.asString())")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                    }
                    
                    if let hygrometer = clock as? Hygrometer {
                        HStack {
                            Text("Humidity")
                            Spacer()
                            Text("\(hygrometer.humidity)%")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
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
//        .onAppear {
//            bleClient.connect(to: peripheral)
//        }.onDisappear {
//            bleClient.disconnect(peripheral)
//        }.popover(isPresented: $isPopoverPresented) {
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
    ClockDetailsView(clock: MockClock())
}
