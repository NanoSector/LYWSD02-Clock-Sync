//
//  LYWSD02.swift
//  LYWSD02 Clock Sync (macOS)
//
//  Created by Rick Kerkhof on 06/11/2021.
//

import Foundation
import CoreBluetooth

/// Based on the LYWSD02 Python library: https://github.com/h4/lywsd02/blob/master/lywsd02/client.py
struct LYWSD02UUID {
    enum Service: String {
        case Unknown1 = "181A" // in advertisement
        case Unknown2 = "FEF5" // in advertisement
        case Data = "EBE0CCB0-7A0A-4B0C-8A1A-6FF2997DA3A6"
    }
    
    enum Characteristic: String {
        case Time = "EBE0CCB7-7A0A-4B0C-8A1A-6FF2997DA3A6" // 5 or 4 bytes, READ WRITE
        case Battery = "EBE0CCC4-7A0A-4B0C-8A1A-6FF2997DA3A6" // 1 byte, READ
        case SensorData = "EBE0CCC1-7A0A-4B0C-8A1A-6FF2997DA3A6" // 3 bytes, READ NOTIFY
    }
}

extension String {
    var uuid: UUID? {
        UUID(uuidString: self)
    }
    
    var cbuuid: CBUUID? {
        guard let uuid = self.uuid else {
            return nil
        }
        return CBUUID(nsuuid: uuid)
    }
}
