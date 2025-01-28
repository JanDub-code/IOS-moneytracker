//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created by Jan Dub on 04.06.2024.
//

import SwiftUI

@main
struct MoneyTrackerApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(welcomeViewModel: WelcomeViewModel(settingsViewModel: SettingsViewModel()),
                        storeViewModel: StoreViewModel(),
                        purchaseViewModel: PurchaseViewModel(),
                        settingsViewModel: SettingsViewModel()
            )
        }
    }
}
