//
//  ThemeManager.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 04/06/25.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var selectedColorScheme: ColorScheme? {
        didSet {
            saveTheme()
        }
    }
    
    private let themeKey = "selectedColorScheme"
    
    init() {
        loadTheme()
    }
    
    func toggleTheme() {
        switch selectedColorScheme {
        case .light:
            selectedColorScheme = .dark
        case .dark:
            selectedColorScheme = nil // Sistema
        default:
            selectedColorScheme = .light
        }
    }
    
    var name: String {
        switch selectedColorScheme {
        case .light:
            return "light"
        case .dark:
            return "dark"
        default:
            return "auto"
        }
    }
    
    var iconName: String {
        switch selectedColorScheme {
        case .light:
            return "sun.max"
        case .dark:
            return "moon"
        default:
            return ""
        }
    }
    
    // MARK: - Persistence
    
    private func saveTheme() {
        let value: Int
        switch selectedColorScheme {
        case .light:
            value = 0
        case .dark:
            value = 1
        default:
            value = 2
        }
        UserDefaults.standard.set(value, forKey: themeKey)
    }
    
    private func loadTheme() {
        let value = UserDefaults.standard.integer(forKey: themeKey)
        switch value {
        case 0:
            selectedColorScheme = .light
        case 1:
            selectedColorScheme = .dark
        default:
            selectedColorScheme = nil
        }
    }
}
