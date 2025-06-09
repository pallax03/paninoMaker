//
//  GamificationManager.swift
//  paninoMaker
//
//  Created by alex mazzoni on 03/06/25.
//

import Foundation

@MainActor
final class GamificationManager {
    static let shared = GamificationManager()
    var user: UserModel = UserModel()
    
    func prepareForUser(_ user: UserModel, panini: [Panino]) {
        self.user = user
        if !user.isLogged {
            user.unlockAll()
        } else {
            recalculateAll(panini: panini)
        }
    }
    
    func recalculateAll(panini: [Panino]) {
        let paniniNotInTrash = panini.filter { !$0.inTrash }
        let totalPoints = paniniNotInTrash.map { $0.points }.reduce(0, +)
        
        for panino in panini {
            panino.refreshBadges(using: paniniNotInTrash)
            panino.points = panino.inTrash ? 0 : panino.calculatePoints()
        }
        
        if user.pex != totalPoints {
            user.pex = totalPoints
            user.level = user.pex / UserGamifications.pointsPerLevelUp
            user.saveUserData()
        }

    }
}
