
import SwiftUI

struct ContentView: View {
    @StateObject var welcomeViewModel: WelcomeViewModel
    @StateObject var storeViewModel: StoreViewModel
    @StateObject var purchaseViewModel: PurchaseViewModel
    @StateObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        TabView {
            WelcomeView(statisticsViewModel: StatisticsViewModel(purchaseViewModel: PurchaseViewModel(), storeViewModel: StoreViewModel(), settingsViewModel: SettingsViewModel()))
                .tabItem {
                    Label("Domů", systemImage: "house")
                }
            
            PurchaseView(purchaseViewModel: purchaseViewModel, storeViewModel: storeViewModel)
                .tabItem {
                    Label("Nákupy", systemImage: "dollarsign")
                }
            
            StoreView(storeViewModel: storeViewModel)
                .tabItem {
                    Label("Obchody", systemImage: "storefront")
                }
            
            StatisticsView(statisticsViewModel: StatisticsViewModel(purchaseViewModel: PurchaseViewModel(), storeViewModel: StoreViewModel(), settingsViewModel: SettingsViewModel()))
                .tabItem {
                    Label("Statistiky", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            SettingsView(settingsViewModel: settingsViewModel)
                .tabItem {
                    Label("Nastavení", systemImage: "ellipsis")
                }
                .toolbarBackground(.indigo, for: .tabBar)
        }
    }
}
