//
//  Item.swift
//  n-vivi1
//
//  Created by ibis on 2025/10/06.
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
