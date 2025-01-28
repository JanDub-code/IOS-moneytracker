//
//  StoreVisitsTupple.swift
//  MoneyTracker
//
//  Created by Dejw on 21.06.2024.
//

import Foundation

struct StoreVisitsTupple: Identifiable, Hashable {
    let id = UUID()
    let store: String
    let sum: Int
}
