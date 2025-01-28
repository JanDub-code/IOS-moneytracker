//
//  StoreDetailView.swift
//  MoneyTracker
//
//  Created by Jan Dub on 04.06.2024.
//

import Foundation
import SwiftUI

struct NewStoreView: View {
    @Binding var newStorePresented: Bool
    @StateObject var storeViewModel: StoreViewModel
    
    @State var storeName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    content: {
                        TextField("Zadejte název obchodu", text: $storeName)
                    },
                    header: {
                        Text("Název:")
                    }
                )
            }
            .navigationTitle("Nový obchod")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Zavřít"){
                        newStorePresented.toggle()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Přidat") {
                        addStore()
                        newStorePresented.toggle()
                    }
                }
            }
        }
    }
    
    func addStore() {
        let newStore = StoreItem()
        newStore.name = storeName
        newStore.visibility = true
        
        storeViewModel.addStore(store: newStore)
        storeViewModel.fetchAllStores() // aby se zobrazil update
    }
}
