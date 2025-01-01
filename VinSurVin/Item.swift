//
//  Item.swift
//  VinSurVin
//
//  Created by Thomas Pelletier on 01/01/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
