//
//  LimitPurchasesTupple.swift
//  MoneyTracker
//
//  Created by Dejw on 21.06.2024.
//

import Foundation

struct LimitPurchasesTupple: Identifiable, Hashable {
    let id = UUID()
    let limit: Double
    let sum: Double
    let stringLimit: String
}
