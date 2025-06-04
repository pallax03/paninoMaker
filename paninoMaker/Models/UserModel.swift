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
    @Published var username: String = "Guest"
    @Published var level: Int = 0
    @Published var pex: Int = 0
    @Published var isLogged: Bool = UserGamifications.enableGamification
    
    func unlockAll() {
        username = "Master User"
        pex = 2405
        level = UserGamifications.levelCap
    }
    
    func levelUp(points: Int) {
        pex += points
        level = min(UserGamifications.levelCap, (pex / UserGamifications.pointsPerLevelUp))
    }
    
    func setLevel(byTotalPoints total: Int) {
        level = min(UserGamifications.levelCap, (total / UserGamifications.pointsPerLevelUp))
        pex = total
    }
    
    // MARK: - LOGIN
    
    
}
