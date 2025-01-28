//
//  PurchaseDetailView.swift
//  MoneyTracker
//
//  Created by Jan Dub on 04.06.2024.
//

import Foundation
import SwiftUI
import RealmSwift

struct SettingsView: View {
    @StateObject var settingsViewModel: SettingsViewModel
    
    @State var limit: String = ""
    @State private var isButtonDisabled = false
    
    let realm = try! Realm()
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    content: {
                        TextField("Zadejte limit", text: $limit)
                        .onChange(of: limit) { oldValue, newValue in
                            toggleButtonActive(value: newValue)
                        }
                    },
                    header: {
                        Text("Limit:")
                    }
                )
            }
            .navigationTitle("Nastavení")
        
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Hotovo") {
                        try! realm.write {
                            settingsViewModel.setting!.limit = Double(limit) ?? 0.0
                        
                        }
                    
                        settingsViewModel.editLimit()
                        settingsViewModel.fetchSettings()
                        isButtonDisabled = true
                    }
                    .disabled(isButtonDisabled)
                }
            }
        
            .onAppear() {
                settingsViewModel.fetchSettings()
                
                limit = String(settingsViewModel.setting?.limit ?? 0.0)
            }
        }
    }
    
    func toggleButtonActive(value: String) {
        if Double(value) == settingsViewModel.setting?.limit {
            isButtonDisabled = true
        } else {
            isButtonDisabled = false
        }
    }
}
