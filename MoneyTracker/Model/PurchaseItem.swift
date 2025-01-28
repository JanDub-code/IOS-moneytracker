//
//  PurchaseItem.swift
//  MoneyTracker
//
//  Created by Jan Dub on 18.06.2024.
//

import Foundation
import MapKit
import RealmSwift

class PurchaseItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var date: Date = Date()
    @Persisted var price: Double = 0.0
    @Persisted var priceStr: String = ""
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    @Persisted var store: String?
    @Persisted var visibility = true
    // TODO: možnost změnit na CLLocationcoordinate2D místo longitude a lattitude
    /* override static func primaryKey() -> String? {
        return "id"
    } */
}

