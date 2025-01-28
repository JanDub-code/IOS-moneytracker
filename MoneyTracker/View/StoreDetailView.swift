//
//  StoreDetailView.swift
//  MoneyTracker
//
//  Created by Jan Dub on 04.06.2024.
//

import Foundation
import SwiftUI
import RealmSwift

struct StoreDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var storeDetailViewModel: StoreDetailViewModel
    @State private var deleteStorePresented: Bool = false
    
    var store: StoreItem {
        storeDetailViewModel.store
    }
    
    @State var storeName: String = ""
    
    let realm = try! Realm()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(
                        content: {
                            TextField("Zadejte název obchodu", text: $storeName)
                        },
                        header: {
                            Text("Název:")
                        }
                    )
                    Section(
                        content: {
                            Button("Smazat obchod") {
                                deleteStorePresented.toggle()
                            }
                            .foregroundColor(.red)
                        }
                    )
                    
                }
            }
        }
        .navigationTitle("Detail obchodu")
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Hotovo") {
                    try! realm.write {
                        storeDetailViewModel.store.name = storeName
                    }
                    
                    storeDetailViewModel.editOrDeleteStore()
                    dismiss()
                }
            }
        }
        
        .onAppear() {
            storeName = store.name
        }
        
        .confirmationDialog(
            "Opravdu chcete obchod smazat? Tato akce je nenávratná.",
             isPresented: $deleteStorePresented
        ) {
            Button("Ano", role: .destructive) {
                withAnimation {
                    try! realm.write {
                        storeDetailViewModel.store.visibility = false
                    }
                    storeDetailViewModel.editOrDeleteStore()
                    dismiss()
                }
            }
            Button("Ne", role: .cancel) {}
        }
        message: {
            Text("Opravdu chcete obchod smazat? Tato akce je nenávratná.")
        }
    }
}
