//
//  StoreView.swift
//  MoneyTracker
//
//  Created by Jan Dub on 04.06.2024.
//

import Foundation
import SwiftUI

struct StoreView: View {
    @State private var newStoreViewPresented: Bool = false
    @StateObject var storeViewModel: StoreViewModel
    @State private var deleteStorePresented: Bool = false
    @State private var itemToDelete: StoreItem?
    
    var body: some View {
        NavigationView {
            List {
                if storeViewModel.storeItems != nil {
                    ForEach(storeViewModel.storeItems!) { item in
                        Section {
                            NavigationLink {
                                StoreDetailView(storeDetailViewModel: StoreDetailViewModel(store: item))
                            }
                            label:
                            {
                                Text("\(item.name)")
                            
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach { index in
                            itemToDelete = storeViewModel.storeItems![index]
                            deleteStorePresented = true
                        }
                    })
                }
            }
            
            .navigationTitle("Obchody")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                            newStoreViewPresented.toggle()
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                }
            }
            
            .sheet(isPresented: $newStoreViewPresented) {
                NewStoreView(
                    newStorePresented: $newStoreViewPresented,
                    storeViewModel: storeViewModel
                )
            }
            
            .onAppear() {
                storeViewModel.fetchAllStores()
            }
            
            .confirmationDialog(
                "Opravdu chcete obchod smazat? Tato akce je nenávratná.",
                isPresented: $deleteStorePresented
            ) {
                  Button("Ano", role: .destructive) {
                      withAnimation {
                          if let item = itemToDelete {
                              storeViewModel.deleteStore(store: item)
                              storeViewModel.fetchAllStores()
                              itemToDelete = nil
                          }
                      }
                  }
                  Button("Ne", role: .cancel) {
                    itemToDelete = nil
                  }
              }
              message: {
                  Text("Opravdu chcete obchod smazat? Tato akce je nenávratná.")
            }
        }
    }
}
