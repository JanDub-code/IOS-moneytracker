//
//  WelcomeViewModel.swift
//  MoneyTracker
//
//  Created by Jan Dub on 04.06.2024.
//

import Foundation
import UIKit
import SwiftUI

class WelcomeViewModel: ObservableObject {
    private var settingsViewModel: SettingsViewModel
    @Published var settingsItems: [SettingsItem] = []
    @Published var mapItems: [PurchaseItem] = []
    @Published var selectedMapItem: PurchaseItem?
    @Published var temperature: String?
    
    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        
        self.settingsViewModel.fetchSettings()
    }
}
