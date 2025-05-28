//
//  Profile.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import SwiftUI
import CloudKit

class UserModel: ObservableObject, Sendable {
    @Published var username: String? = "PreviewUser"
    @Published var level: Int = 1
    @Published var pex: Int = 0
    @Published var isLoggedIn: Bool = false

    private var cloudKitManager: CloudKitManager? = nil
    private var gameCenterHelper: GameCenterHelper? = nil

    init() {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            // Siamo in preview, inizializza con dati mock
            return
        }
        #endif
        
        // Qui il codice reale che si connette a Game Center o CloudKit
        cloudKitManager = CloudKitManager()
        gameCenterHelper = GameCenterHelper()
        Task {
            await self.setupGameCenter()
        }
    }
    
    func setupGameCenter() async {
        do{
            gameCenterHelper!.authenticate()
            gameCenterHelper?.$isAuthenticated
                .receive(on: DispatchQueue.main)
                .assign(to: &$isLoggedIn)

            gameCenterHelper!.$playerAlias
                .receive(on: DispatchQueue.main)
                .assign(to: &$username)

            if isLoggedIn {
                loadUserData()
            } else {
                unlockAllIngredients()
            }
        } catch {
            username = nil
        }
    }

    func unlockAllIngredients() {
        // Logica per sbloccare tutto ignorando il livello
    }

    func levelUp(points: Int) {
        pex += points
        level = Int(sqrt(Double(pex) * 1.25))
        saveUserData()
    }
    
    func loadUserData() {
        Task {
            do {
                let data = try await cloudKitManager?.fetchUserData()
                DispatchQueue.main.async {
                    self.level = data!.level
                    self.pex = data!.pex
                    self.username = data?.username
                }
            } catch {
                print("Error loading user data: \(error)")
            }
        }
    }

    func saveUserData() {
        Task {
            do {
                let data = UserData(username: username, level: level, pex: pex)
                try await cloudKitManager?.saveUserData(data)
            } catch {
                print("Error saving user data: \(error)")
            }
        }
    }
}

struct UserData: Codable {
    var username: String?
    var level: Int
    var pex: Int
}
