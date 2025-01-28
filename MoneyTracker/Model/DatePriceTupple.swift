//
//  DatePriceTupple.swift
//  MoneyTracker
//
//  Created by Dejw on 20.06.2024.
//

import Foundation

struct DatePriceTupple: Identifiable, Hashable {
    let id = UUID()
    let day: Int
    let month: Int
    let sum: Double
}
