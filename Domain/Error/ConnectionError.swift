//
//  ConnectionError.swift
//  LYWSD02 Clock Sync (iOS)
//
//  Created by Rick Kerkhof on 01/03/2024.
//

import Foundation

struct ConnectionError: Error {
    var clock: any Clock
}
