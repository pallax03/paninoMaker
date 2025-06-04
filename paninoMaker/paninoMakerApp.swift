//
//  paninoMakerApp.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import SwiftUI
import SwiftData

@main
struct paninoMakerApp: App {
    @StateObject private var user = UserModel()
    @StateObject private var themeManager = ThemeManager()
    let ingredientStore = IngredientStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.ingredientStore, ingredientStore)
                .environmentObject(user)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.selectedColorScheme)
        }
        .modelContainer(for: [Menu.self, Panino.self])
    }
}
