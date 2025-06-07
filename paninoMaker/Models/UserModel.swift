//
//  UserModel.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import SwiftUI

enum UserGamifications {
    static let enableGamification: Bool = false
    static let levelCap = 5
    static let pointsPerLevelUp: Int = 100
}

class UserModel: ObservableObject {
    var username: String = "Guest"
    var level: Int = 4
    var pex: Int = 456
    var isLogged: Bool = UserGamifications.enableGamification
    
    func unlockAll() {
        username = "Master User"
        pex = 2405
        level = UserGamifications.levelCap
    }
    
    func levelUp(points: Int) {
        if isLogged {
            pex += points
            level = isLevelUpAvailable(pex / UserGamifications.pointsPerLevelUp)
        }
    }
    
    func isLevelUpAvailable(_ lvl: Int) -> Int {
        let newLevel = min(UserGamifications.levelCap, lvl)
        if level != newLevel {
            sendNotification(newLevel)
        }
        return newLevel
    }
    // MARK: - LOGIN
    
    
}
