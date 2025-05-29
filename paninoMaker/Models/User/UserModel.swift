//
//  Profile.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import SwiftUI
import CloudKit

class UserModel: ObservableObject {
    @Published var username: String = "Guest"
    @Published var level: Int = 3
    @Published var pex: Int = 0
    @Published var isLogged: Bool = UserGamifications.enableGamification
    
    func unlockAll() {
        level = UserGamifications.levelCap
    }
    
    func levelUp(points: Int) {
        pex += points
    }
    
}
