import Foundation
import SwiftUI
import RealmSwift
import MapKit

struct NewPurchaseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isDetailViewPresented = false

    @Binding var newPurchasePresented: Bool
    
    @StateObject var purchaseViewModel: PurchaseViewModel
    @StateObject var storeViewModel: StoreViewModel
    
    @State var purchasePrice: String = ""
    @State var selectedStore: StoreItem?
    @State var date = Date.now
    @State var calendarId: Int = 0
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    @State var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    let realm = try! Realm()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cena:")) {
                    TextField("Zadejte cenu", text: $purchasePrice)
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
                    }), isMapPickerPresented: $isDetailViewPresented), isActive: $isDetailViewPresented) {
                        Text("Vyberte lokaci nákupu:")
                    }
                    
                    Text("Vybraná lokace: \(latitude), \(longitude)")
                }
                footer: {
                    HStack {
                        Text("Aktuální lokace: \(latitude), \(longitude)")
                    }
                }
            }
            .navigationTitle("Detail nákupu")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Zavřít") {
                        newPurchasePresented.toggle()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Přidat") {
                        addPurchase()
                        newPurchasePresented.toggle()
                    }
                }
            }
            .onAppear {
                storeViewModel.fetchAllStores()
            }
        }
    }
    
    func addPurchase() {
        let newPurchase = PurchaseItem()
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        newPurchase.price = Double(purchasePrice) ?? 0.0
        newPurchase.priceStr = formatter.string(from: NSNumber(value: Double(purchasePrice) ?? 0.0)) ?? "0.00"
        newPurchase.date = date
        newPurchase.store = selectedStore?.id
        newPurchase.latitude = latitude
        newPurchase.longitude = longitude
        newPurchase.visibility = true
        
        purchaseViewModel.addPurchase(purchase: newPurchase)
        purchaseViewModel.fetchAllPurchasesInMonth()
    }
}
