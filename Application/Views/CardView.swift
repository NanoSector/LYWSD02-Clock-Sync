//
//  CardView.swift
//  LYWSD02 Clock Sync
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation
import SwiftUI

public struct XiaomiLYWSD02ClockView: View {
    var clock: any Clock

    public var body: some View {
        VStack {
            VStack(alignment: .trailing) {
                Text(clock.time.date, style: .time)
                    .font(.system(size: 80))
                    .fontDesign(.monospaced)
                
                HStack(spacing: 20) {
                    if let hygrometer = clock as? Hygrometer {
                        HStack(alignment: .bottom, spacing: 0) {
                            Text(String(hygrometer.humidity))
                                .fontDesign(.monospaced)
                            
                            Text("%")
                                    .fontDesign(.monospaced)
                                    .font(.footnote)
                        }
                    }
                    
                    if let thermometer = clock as? Thermometer {
                        HStack(alignment: .bottom, spacing: 0) {
                            Text(String(thermometer.temperature))
                                .fontDesign(.monospaced)
                            
                            Text("°\(thermometer.temperatureUnit.asString())")
                                    .fontDesign(.monospaced)
                                    .font(.footnote)
                        }
                    }
                    
                    Text("(^_^)")
                        .fontDesign(.monospaced)
                }
            }.padding(EdgeInsets(top: 0, leading: 30, bottom: 10, trailing: 30))
                .foregroundStyle(.black)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(red: 0.39, green: 0.39, blue: 0.39), lineWidth: 2)
                }
        }
        .padding(30)
        .background(Color(red: 0.70, green: 0.70, blue: 0.70))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.39, green: 0.39, blue: 0.39), lineWidth: 5)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 15)
    }
}

#Preview("Mock clock") {
    XiaomiLYWSD02ClockView(clock: MockClock())
        .previewLayout(.sizeThatFits)
}
