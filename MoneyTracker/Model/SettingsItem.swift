//
//  SettingsItem.swift
//  MoneyTracker
//
//  Created by Jan Dub on 18.06.2024.
//


import Foundation
import RealmSwift

class SettingsItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var limit: Double = 0.0
}
