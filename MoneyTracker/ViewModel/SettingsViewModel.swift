//
//  StoreDetailViewModel.swift
//  MoneyTracker
//
//  Created by Dejw on 05.06.2024.
//

import Foundation
import RealmSwift

class SettingsViewModel: ObservableObject {
    @Published var setting: SettingsItem?
    
    let realm = try! Realm()
    
    func editLimit() {
       do {
            try realm.write {

            }
            
        } catch {
            print("Settings not found")
        }
    }
    
    func fetchSettings() {
        setting = realm.object(ofType: SettingsItem.self, forPrimaryKey: 0)
        
        if setting == nil {
            addStartSettings()
        }
        
        setting = realm.object(ofType: SettingsItem.self, forPrimaryKey: 0)
    }
    
    func addStartSettings(){
        do {
            try realm.write {
                realm.add(SettingsItem())
            }
        } catch {
            print("An error occurred while saving the category: \(error)")
        }
    }
}
