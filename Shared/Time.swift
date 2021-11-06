//
//  Time.swift
//  LYWSD02 Clock Sync
//
//  Created by Rick Kerkhof on 05/11/2021.
//

import Foundation

struct Time {
    var timestamp = Int(NSDate().timeIntervalSince1970)
    var timezoneOffset = 1
    
    func data() -> Data {
        pack("<Ib", [timestamp, timezoneOffset])
    }
}
