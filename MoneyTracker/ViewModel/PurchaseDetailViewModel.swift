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

class PurchaseDetailViewModel: ObservableObject {
    @Published var purchase: PurchaseItem

    init(purchase: PurchaseItem) {
        self.purchase = purchase
    }
    
    let realm = try! Realm()
    
    func editOrDeletePurchase() {
       do {
            try realm.write {

            }
            
        } catch {
            print("Store not found")
        }
    }
}
