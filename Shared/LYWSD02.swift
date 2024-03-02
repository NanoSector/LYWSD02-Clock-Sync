//
//  LYWSD02.swift
//  LYWSD02 Clock Sync (macOS)
//
//  Created by Rick Kerkhof on 06/11/2021.
//

import Foundation
import CoreBluetooth

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
