//
//  StatisticsViewModel.swift
//  MoneyTracker
//
//  Created by Dejw on 20.06.2024.
//

import Foundation
import SwiftUI

class StatisticsViewModel: ObservableObject {
    private var purchaseViewModel: PurchaseViewModel
    private var storeViewModel: StoreViewModel
    private var settingsViewModel: SettingsViewModel
    @Published var puchasesByDatesTuples: [DatePriceTupple] = []
    @Published var storesByVisitsTuples: [StoreVisitsTupple] = []
    @Published var limitPurchasesTupple: LimitPurchasesTupple = LimitPurchasesTupple(limit: 0.0, sum: 0.0, stringLimit: "0.0")
    @Published var year: Int = 1
    @Published var month: Int = 1900

    init(purchaseViewModel: PurchaseViewModel, storeViewModel: StoreViewModel, settingsViewModel: SettingsViewModel) {
        self.purchaseViewModel = purchaseViewModel
        self.storeViewModel = storeViewModel
        self.settingsViewModel = settingsViewModel
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        self.month = calendar.component(.month, from: currentDate)
        self.year = calendar.component(.year, from: currentDate)
    }
    
    func changeStatistics(num: Int) {
        month = month + num
        
        if month < 1 {
            month = 12
            year-=1
        }
        
        if month > 12 {
            month = 1
            year += 1
        }
        
        fetchPurchasesPriceTuppleInMonth(month: self.month, year: self.year)
        getLimitPurchasesTupple(month: self.month, year: self.year)
        getStoreVisitsTupple(month: self.month, year: self.year)
    }
    
    func fetchPurchasesPriceTuppleInMonth(month: Int, year: Int) {
        puchasesByDatesTuples = []
        
        purchaseViewModel.month = month
        purchaseViewModel.year = year
        
        let dateComponents = DateComponents(year: self.year, month: self.month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        purchaseViewModel.fetchAllPurchasesInMonth()
        
        for i in 1...numDays {
            var sum: Double = 0.0
            
            for item in purchaseViewModel.purchaseItems {
                let currentDate = item.date

                let calendar = Calendar.current

                let month = calendar.component(.month, from: currentDate)
                let day = calendar.component(.day, from: currentDate)
                
                if(month == self.month && day == i) {
                    sum+=item.price
                    
                }
            }
            
            puchasesByDatesTuples.append(
                DatePriceTupple(
                    day: i, month: self.month, sum: sum
                )
            )
        }
    }
    
    func getLimitPurchasesTupple(month: Int, year: Int) {
        
        settingsViewModel.fetchSettings()
        
        let limit = settingsViewModel.setting?.limit

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let limitString = formatter.string(from: NSNumber(value: limit ?? 0.0))
        
        
        
        purchaseViewModel.month = month
        purchaseViewModel.year = year
        purchaseViewModel.fetchAllPurchasesInMonth()
        var sum = 0.0
        
        for item in purchaseViewModel.purchaseItems {
            sum += item.price
        }
        
        limitPurchasesTupple = LimitPurchasesTupple(limit: limit ?? 0.0, sum: sum, stringLimit: limitString ?? "0.0")
    }
    
    func getStoreVisitsTupple(month: Int, year: Int) {
        storesByVisitsTuples = []
        
        purchaseViewModel.month = month
        purchaseViewModel.year = year
        
        purchaseViewModel.fetchAllPurchasesInMonth()
        storeViewModel.fetchAllStores()
    
        for storee in storeViewModel.storeItems ?? [] {
            var sum: Int = 0
            
            for purchase in purchaseViewModel.purchaseItems {
                if(purchase.store == storee.id) {
                    sum+=1
                }
            }
            
            if(sum > 0) {
                storesByVisitsTuples.append(
                    StoreVisitsTupple(store: storee.name, sum: sum)
                )
            }
        }
    }
    
    func getPurchasesByCoordinates() -> [PurchaseItem] {
        purchaseViewModel.month = self.month
        purchaseViewModel.year = self.year
        
        purchaseViewModel.fetchAllPurchasesInMonth()
        
        let filteredPurchasesByCoords = purchaseViewModel.purchaseItems.filter({
            $0.latitude != 0.0 && $0.longitude != 0.0
        })
        
        return filteredPurchasesByCoords
        
    }
    
    func calculateWidth(val: CGFloat) -> CGFloat {
        let limit = getLimit()
        
        let sum: Double = getPurchasesPriceSum()
        
        var ratio: Double = (sum / limit)
        
        if(ratio > 1.0) {
            ratio = 1.0
        }
        return val * ratio
    }
    
    func getBarColor() -> Color {
        if(getPurchasesPriceSum() > getLimit()) {
            return Color.red
        }
        
        return Color.green
    }
    
    func getLimit() -> Double {
        settingsViewModel.fetchSettings()
        
        return settingsViewModel.setting?.limit ?? 0.0
    }
    
    func getPurchasesPriceSum() -> Double {
        purchaseViewModel.month = self.month
        purchaseViewModel.year = self.year
        
        purchaseViewModel.fetchAllPurchasesInMonth()
        
        var sum: Double = 0.0
        
        for purchase in purchaseViewModel.purchaseItems {
            sum+=purchase.price
        }
        
        return sum
    }
    
    func getLimitStr() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
       
        let limitString = formatter.string(from: NSNumber(value: getLimit()))
        
        return limitString ?? "0.00"
    }
    
    func getPurchasesPriceSumStr() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
       
        let sumString = formatter.string(from: NSNumber(value: getPurchasesPriceSum()))
        
        return sumString ?? "0.00"
    }
}
