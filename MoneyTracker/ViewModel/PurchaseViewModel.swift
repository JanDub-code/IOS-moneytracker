//
//  PurchaseDetailViewModel.swift
//  MoneyTracker
//
//  Created by Dejw on 05.06.2024.
//

import Foundation
import UIKit
import SwiftUI
import RealmSwift

class PurchaseViewModel: ObservableObject {
    @Published var purchaseItems: [PurchaseItem] = []
    @Published var selectedPurchaseItem: PurchaseItem?
    @Published var year: Int = 1
    @Published var month: Int = 1900
    
    init() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        self.month = calendar.component(.month, from: currentDate)
        self.year = calendar.component(.year, from: currentDate)
    }
    
    let realm = try! Realm()
    
    func fetchAllPurchasesInMonth() {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        guard let startDate = calendar.date(from: dateComponents) else { return }
        
        var components = DateComponents()
        components.month = 1
        components.second = -1
        guard let endDate = calendar.date(byAdding: components, to: startDate) else { return }
        
        purchaseItems = Array(realm.objects(PurchaseItem.self).filter("visibility == true AND date >= %@ AND date < %@", startDate, endDate))
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        for item in purchaseItems {

            //item.price = Double(formatter.string(from: NSNumber(value: item.price ?? 0.0)))
        }
        
    }

    
    func addPurchase(purchase: PurchaseItem){
        do {
            try realm.write {
                realm.add(purchase)
            }
        } catch {
            print("An error occurred while saving the category: \(error)")
        }
    }
    
    /* func findStoreById(id: UUID) -> StoreItem? {
         let id = id.uuidString
         return  realm.object(ofType: StoreItem.self, forPrimaryKey: id)
        
    } */
    
    func changePurchaseList(num: Int) {
        month = month + num
        
        if month < 1 {
            month = 12
            year-=1
        }
        
        if month > 12 {
            month = 1
            year += 1
        }
        
        fetchAllPurchasesInMonth()
    }
    
    func getTotalPricesByStore() -> [(store: String, total: Double)] {
        // Seskupíme položky nákupů podle obchodů a spočítáme celkové ceny
        let storeGroups = Dictionary(grouping: purchaseItems, by: { $0.store ?? "Unknown" })
        
        // Vytvoříme pole tuple (obchod, celková cena)
        let totals = storeGroups.map { (store, items) in
            let total = items.reduce(0.0) { $0 + $1.price }
            return (store: store, total: total)
        }
        
        // Seřadíme výsledky podle celkové ceny sestupně
        let sortedTotals = totals.sorted { $0.total > $1.total }
        
        return sortedTotals
    }
    
    func deletePurchase(purchase: PurchaseItem) {
       do {
            try realm.write {
                purchase.visibility = false
            }
            
        } catch {
            print("Store not found")
        }
    }
}
