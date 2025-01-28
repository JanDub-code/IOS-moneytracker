//
//  PurchaseView.swift
//  MoneyTracker
//
//  Created by Jan Dub on 04.06.2024.
//

import Foundation
import SwiftUI

struct PurchaseView: View {
    @State private var newPurchaseViewPresented: Bool = false
    @StateObject var purchaseViewModel: PurchaseViewModel
    @StateObject var storeViewModel: StoreViewModel
    @State private var deletePurchasePresented: Bool = false
    @State private var itemToDelete: PurchaseItem?
    @GestureState private var dragOffset = CGSize.zero
    @State private var position: CGSize = .zero
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Spacer()
                        Text("\( purchaseViewModel.month < 10 ? "0" + String(purchaseViewModel.month) : String(purchaseViewModel.month)). \(String(purchaseViewModel.year))")
                        Spacer()
                    }
                }
            
                ForEach(purchaseViewModel.purchaseItems) { item in
                    Section {
                        NavigationLink {
                            PurchaseDetailView(purchaseDetailViewModel: PurchaseDetailViewModel(purchase: item), storeViewModel: StoreViewModel())
                        }
                        label:
                        {
                            VStack(alignment: .leading) {
                                Text("Cena: \(item.priceStr)")
                                Spacer()
                                if item.store != nil {
                                    Text("Obchod: \(storeViewModel.findStoreById(id: UUID(uuidString: item.store!)!)!.name)")
                                } else {
                                    Text("Obchod: Žádný")
                                }
                            }
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        itemToDelete = purchaseViewModel.purchaseItems[index]
                        deletePurchasePresented = true
                    }
                })
            }
            .navigationTitle("Nákupy")
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                            newPurchaseViewPresented.toggle()
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                }
            }
            
            .sheet(isPresented: $newPurchaseViewPresented) {
                NewPurchaseView(
                    newPurchasePresented: $newPurchaseViewPresented,
                    purchaseViewModel: purchaseViewModel, storeViewModel: storeViewModel
                )
            }
            
            .onAppear() {
                purchaseViewModel.fetchAllPurchasesInMonth()
            }
            
            .confirmationDialog(
                "Opravdu chcete nákup smazat? Tato akce je nenávratná.",
                isPresented: $deletePurchasePresented
            ) {
                  Button("Ano", role: .destructive) {
                      withAnimation {
                          if let item = itemToDelete {
                              purchaseViewModel.deletePurchase(purchase: item)
                              purchaseViewModel.fetchAllPurchasesInMonth()
                              itemToDelete = nil
                          }
                      }
                  }
                  Button("Ne", role: .cancel) {
                    itemToDelete = nil
                  }
              }
              message: {
                  Text("Opravdu chcete nákup smazat? Tato akce je nenávratná.")
            }
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    withAnimation {
                        if value.translation.width < -100 {
                            purchaseViewModel.changePurchaseList(num: 1)
                            position = CGSize(width: -200, height: 0)
                        } else if value.translation.width > 100 {
                            purchaseViewModel.changePurchaseList(num: -1)
                            position = CGSize(width: 200, height: 0)
                        } else {
                            position = .zero
                        }
                    }
                    // Reset position after animation
                    withAnimation(.spring()) {
                        position = .zero
                    }
                }
        )
        .animation(.spring(), value: dragOffset)
    }
}
