//
//  StoreViewModel.swift
//  MoneyTracker
//
//  Created by Dejw on 04.06.2024.
//

import Foundation
import UIKit
import SwiftUI
import RealmSwift

class StoreViewModel: ObservableObject {
    @Published var storeItems: [StoreItem]?
    @Published var selectedStoreItem: StoreItem?
    
    init() {
        
    }
    
    let realm = try! Realm()
    
    func fetchAllStores() {
         storeItems = Array(realm.objects(StoreItem.self).filter("visibility == true"))
     }
    
    func addStore(store: StoreItem){
        do {
            try realm.write {
                realm.add(store)
            }
        } catch {
            print("An error occurred while saving the category: \(error)")
        }
    }
    
    func findStoreById(id: UUID) -> StoreItem? {
         let id = id.uuidString
         return  realm.object(ofType: StoreItem.self, forPrimaryKey: id)
        
    }
    
    func deleteStore(store: StoreItem) {
       do {
            try realm.write {
                store.visibility = false
            }
            
        } catch {
            print("Store not found")
        }
    }
}
