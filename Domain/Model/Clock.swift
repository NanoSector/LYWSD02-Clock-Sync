//
//  AbstractClock.swift
//  LYWSD02 Clock Sync (iOS)
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation

protocol Clock: Identifiable {
    var id: UUID { get }
    var friendlyName: String { get }
    
    var kind: ClockModel { get }
    var time: Time { get set }
}
