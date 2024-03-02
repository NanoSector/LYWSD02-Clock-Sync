//
//  Time.swift
//  LYWSD02 Clock Sync
//
//  Created by Rick Kerkhof on 05/11/2021.
//

import Foundation

struct Time {
    var date: Date = Date()
    var timezoneOffset: Int = 1
    
    func data() -> Data {
        pack("<Ib", [Int(self.date.timeIntervalSince1970), timezoneOffset])
    }
}
