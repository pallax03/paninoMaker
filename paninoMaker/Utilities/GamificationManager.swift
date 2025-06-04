//
//  GamificationManager.swift
//  paninoMaker
//
//  Created by alex mazzoni on 03/06/25.
//

import Foundation

final class GamificationManager {
    static let shared = GamificationManager()

    func prepareForUser(_ user: UserModel, panini: [Panino]) {
            if !user.isLogged {
                user.unlockAll()
            } else {
                recalculateAll(panini: panini, user: user)
            }
        }

    func update(panino: Panino, allPanini: [Panino], user: UserModel) {
        panino.refreshBadges(using: allPanini)
        user.levelUp(points: panino.calculatePoints())
    }

    func recalculateAll(panini: [Panino], user: UserModel) {
        print("[DEBUG] \(panini.count) Panini: \(panini) [END]")
        for panino in panini {
            self.update(panino: panino, allPanini: panini, user: user)
        }
        let totalPoints = panini.reduce(0) { $0 + $1.calculatePoints() }
        user.setLevel(byTotalPoints: totalPoints)
        print("[DEBUG] Total points: \(totalPoints) [END]")
    }
}
