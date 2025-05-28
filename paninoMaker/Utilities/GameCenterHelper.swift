//
//  GameCenterHelper.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import GameKit

class GameCenterHelper: ObservableObject {
    @Published var playerID: String? = nil
    @Published var playerAlias: String? = nil
    @Published var isAuthenticated: Bool = false
    
    func authenticate() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            if let vc = vc {
                // Mostra schermata di login Game Center (devi gestirla in UI)
            } else if GKLocalPlayer.local.isAuthenticated {
                self.playerID = GKLocalPlayer.local.gamePlayerID
                self.playerAlias = GKLocalPlayer.local.alias
                self.isAuthenticated = true
            } else {
                self.isAuthenticated = false
            }
        }
    }
}
