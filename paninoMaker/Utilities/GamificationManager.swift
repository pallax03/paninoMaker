//
//  GamificationManager.swift
//  paninoMaker
//
//  Created by alex mazzoni on 03/06/25.
//

import Foundation

final class GamificationManager {
    static let shared = GamificationManager()
    
    @MainActor
    func prepareForUser(_ user: UserModel, panini: [Panino]) {
        if !user.isLogged {
            user.unlockAll()
        } else {
            let points = panini.filter { !$0.inTrash }.map { $0.points }.reduce(0, +)
            print("user: \(user.pex) == total points: \(points) ? ")
            if user.pex != points {
                user.levelUp(points: points - user.pex)
            }
            print("user: \(user.pex) == total points: \(points) ? \(user.pex == points)")
        }
    }
    
    @MainActor
    func update(panino: Panino, allPanini: [Panino], user: UserModel) {
        assert(Thread.isMainThread, "update deve essere chiamato sul main thread")
        panino.refreshBadges(using: allPanini.filter { !$0.inTrash })
        let oldPoints: Int = panino.points
        let newPoints: Int = panino.calculatePoints()
        let delta: Int = newPoints - oldPoints
        print("newPoints: \(newPoints) - oldPoints: \(oldPoints) = delta: \(delta)")
        if panino.inTrash {
            // Do nothing, no points should be added
        } else if oldPoints == 0 {
            // Panino was restored or newly added
            user.levelUp(points: newPoints)
            panino.points = newPoints
            print("Panino restored or added. Added \(newPoints) to pex. New pex: \(user.pex)")
        } else if delta != 0 {
            // Normal update: remove old, add new
            user.pex -= oldPoints
            user.levelUp(points: newPoints)
            panino.points = newPoints
            print("Updated panino. delta: \(delta), new pex: \(user.pex)")
        }
        let totalPoints = allPanini.filter { !$0.inTrash }.map { $0.points }.reduce(0, +)
        print("user: \(user.pex) == total points: \(totalPoints) ? \(user.pex == totalPoints)")
    }
    
    @MainActor
    func recalculateAll(panini: [Panino], user: UserModel) {
        let newTotal = panini.filter { !$0.inTrash }.map { $0.calculatePoints() }.reduce(0, +)
        let delta = newTotal - user.pex
        if delta != 0 {
            user.pex = newTotal
            user.level = user.pex / UserGamifications.pointsPerLevelUp
            user.saveUserData()
        }
        
        for panino in panini {
            let oldPoints = panino.points
            panino.refreshBadges(using: panini.filter { !$0.inTrash })
            let newPoints = panino.calculatePoints()
            if oldPoints != newPoints {
                panino.points = newPoints
            }
        }
    }
}
