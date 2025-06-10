//
//  paninoMakerApp.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct paninoMakerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var user = UserModel()
    @StateObject private var themeManager = ThemeManager()
    let ingredientStore = IngredientStore()
    private let notificationDelegate = NotificationDelegate()
    
    init() {
        requestNotificationPermission()
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.ingredientStore, ingredientStore)
                .environmentObject(user)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.selectedColorScheme)
                .onAppear {
                    if Auth.auth().currentUser != nil {
                        Task {
                            await user.syncUserData()
                        }
                    }
                }
        }
        .modelContainer(for: [MenuModel.self, Panino.self])
    }
}
