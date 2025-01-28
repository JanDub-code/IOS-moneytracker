//
//  StoreItem.swift
//  MoneyTracker
//
//  Created by Jan Dub on 18.06.2024.
//

import Foundation
import MapKit
import RealmSwift

class StoreItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var visibility: Bool = true
    
    /* override static func primaryKey() -> String? {
        return "id"
    } */
}
