//
//  StoreDetailViewModel.swift
//  MoneyTracker
//
//  Created by Dejw on 05.06.2024.
//

import Foundation
import RealmSwift

class StoreDetailViewModel: ObservableObject {
    @Published var store: StoreItem

    init(store: StoreItem) {
        self.store = store
    }
    
    let realm = try! Realm()
    
    func editOrDeleteStore() {
       do {
            try realm.write {

            }
            
        } catch {
            print("Store not found")
        }
    }
}
