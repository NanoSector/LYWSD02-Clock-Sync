//
//  DeviceView.swift
//  LYWSD02 Clock Sync (macOS)
//
//  Created by Rick Kerkhof on 05/11/2021.
//

import CoreBluetooth
import SwiftUI

struct DeviceView: View {
    @EnvironmentObject var bleClient: BLEClient
    
    @ObservedObject var peripheral: BLEDeviceModel
    
    @State var isPopoverPresented = false
    @State var targetDate = Date()
    
    var columns: [GridItem] = [
        GridItem(.flexible(), alignment: .trailing),
        GridItem(.flexible(), alignment: .leading),
    ]
    
    var body: some View {
        VStack {
            if let time = peripheral.currentTime {
                Text(time, style: .time).font(.largeTitle).padding().onTapGesture {
                    isPopoverPresented = true
                }
            }
            
            LazyVGrid(columns: columns) {
                if peripheral.hasBatterySupport {
                    // TODO: show appropriate icon for state
                    Image(systemName: "battery.100").frame(width: 30)
                    if let percent = peripheral.batteryPercentage {
                        Text(String(percent) + "%")
                    } else {
                        Text("N/A")
                    }
                }
                
                if peripheral.hasTemperatureSupport {
                    Image(systemName: "thermometer").frame(width: 30)
                    if let percent = peripheral.currentTemperature {
                        Text(String(percent) + " °C")
                    } else {
                        Text("N/A")
                    }
                }
                
                if peripheral.hasHumiditySupport {
                    Image(systemName: "drop").frame(width: 30)
                    if let percent = peripheral.currentHumidity {
                        Text(String(percent) + "%")
                    } else {
                        Text("N/A")
                    }
                }
            }
            
            GroupBox(label: Text("Discovered capabilities")) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: peripheral.hasTimeSupport ? "checkmark.circle.fill" : "xmark.circle")
                        Text("Read & write time")
                    }
            
                    HStack {
                        Image(systemName: peripheral.hasBatterySupport ? "checkmark.circle.fill" : "xmark.circle")
                        Text("Read battery status")
                    }
                
                    HStack {
                        Image(systemName: peripheral.hasTemperatureSupport ? "checkmark.circle.fill" : "xmark.circle")
                        Text("Read temperature")
                    }
                
                    HStack {
                        Image(systemName: peripheral.hasHumiditySupport ? "checkmark.circle.fill" : "xmark.circle")
                        Text("Read humidity")
                    }
                }.padding()
            }.padding()
        }.toolbar {
            Button(action: {
                peripheral.sync()
            }) {
                Image(systemName: "arrow.clockwise")
                Text("Sync")
            }
        }.onAppear {
            bleClient.connect(to: peripheral)
        }.onDisappear {
            bleClient.disconnect(peripheral)
        }.popover(isPresented: $isPopoverPresented) {
            VStack {
                HStack {
                    DatePicker("", selection: $targetDate)
                        .labelsHidden()
                
                    Button {
                        peripheral.syncTime(target: targetDate)
                    } label: {
                        Image(systemName: "clock.badge.checkmark")
                        Text("Set this time")
                    }
                }.padding()
                Button {
                    peripheral.syncTime(target: Date())
                } label: {
                    Image(systemName: "clock.arrow.2.circlepath")
                    Text("Sync with device")
                }
            }.padding()
        }.navigationTitle(peripheral.name)
    }
}

// struct DeviceView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeviceView(peripheral: BLEDeviceModel())
//    }
// }
