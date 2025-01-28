import SwiftUI
import RealmSwift
import MapKit

struct PurchaseDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isMapViewPresented = false
    
    @StateObject var purchaseDetailViewModel: PurchaseDetailViewModel
    @StateObject var storeViewModel: StoreViewModel
    @State private var deletePurchasePresented: Bool = false
    
    var purchase: PurchaseItem {
        purchaseDetailViewModel.purchase
    }
    
    @State var price: String = ""
    @State var selectedStore: StoreItem?
    @State var date = Date.now
    @State var calendarId: Int = 0
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    
    let realm = try! Realm()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cena:")) {
                    TextField("Zadejte cenu", text: $price)
                }
                
                Section {
                    Picker("Obchod:", selection: $selectedStore) {
                        Text("Žádný").tag(nil as StoreItem?)
                        if let storeItems = storeViewModel.storeItems {
                            ForEach(storeItems) { store in
                                Text(store.name).tag(store as StoreItem?)
                            }
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section {
                    DatePicker("Vyberte datum:", selection: $date, displayedComponents: [.date])
                        .id(calendarId)
                        .onChange(of: date) { oldValue, newValue  in
                            calendarId += 1
                        }
                }
                
                Section {
                    NavigationLink(destination: MapView(selectedCoordinate: .init(get: {
                        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    }, set: { newCoordinate in
                        latitude = newCoordinate.latitude
                        longitude = newCoordinate.longitude
                    }), isMapPickerPresented: $isMapViewPresented), isActive: $isMapViewPresented) {
                        Text("Vyberte lokaci nákupu:")
                    }
                    
                    Text("Vybraná lokace: \(latitude), \(longitude)")
                }
                footer: {
                    HStack {
                        Text("Aktuální lokace: \(purchase.latitude ?? 0.0), \(purchase.longitude ?? 0.0)")
                    }
                }
                
                Section {
                    Button("Smazat nákup") {
                        deletePurchasePresented.toggle()
                    }
                    .foregroundColor(.red)
                }
            }}
            .navigationTitle("Detail nákupu")
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Hotovo") {
                        let formatter = NumberFormatter()
                        formatter.minimumFractionDigits = 2
                        formatter.maximumFractionDigits = 2
                        
                        try! realm.write {
                            purchaseDetailViewModel.purchase.price = Double(price) ?? 0.0
                            purchaseDetailViewModel.purchase.priceStr = formatter.string(from: NSNumber(value: Double(price) ?? 0.0)) ?? "0.00"
                            
                            purchaseDetailViewModel.purchase.store = selectedStore?.id
                            purchaseDetailViewModel.purchase.date = date
                            purchaseDetailViewModel.purchase.latitude = latitude
                            purchaseDetailViewModel.purchase.longitude = longitude
                        }
                        
                        purchaseDetailViewModel.editOrDeletePurchase()
                        dismiss()
                    }
                }
            }
            
            .onAppear {
                price = String(purchase.price)
                date = purchase.date
                latitude = purchase.latitude ?? 0.0
                longitude = purchase.longitude ?? 0.0
                
                if let storeId = purchase.store, let store = storeViewModel.findStoreById(id: UUID(uuidString: storeId)!) {
                    selectedStore = store
                } else {
                    selectedStore = nil
                }
                
                storeViewModel.fetchAllStores()
            }
            
            .confirmationDialog(
                "Opravdu chcete nákup smazat? Tato akce je nenávratná.",
                isPresented: $deletePurchasePresented
            ) {
                Button("Ano", role: .destructive) {
                    withAnimation {
                        try! realm.write {
                            purchaseDetailViewModel.purchase.visibility = false
                        }
                        purchaseDetailViewModel.editOrDeletePurchase()
                        dismiss()
                    }
                }
                Button("Ne", role: .cancel) {}
            }
        message: {
            Text("Opravdu chcete nákup smazat? Tato akce je nenávratná.")
        }
    }
}
