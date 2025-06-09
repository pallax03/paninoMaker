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
    
    func prepareForUser(_ user: UserModel, panini: [Panino]) {
        if !user.isLogged {
            user.unlockAll()
        } else {
            let paniniNotInTrash = panini.filter { !$0.inTrash }
            let points = paniniNotInTrash.map { $0.points }.reduce(0, +)
            print("user: \(user.pex) == total points: \(points) ? ")
            if user.pex != points {
                user.levelUp(points: points - user.pex)
            }
            print("user: \(user.pex) == total points: \(points) ? \(user.pex == points)")
        }
    }
    
    func update(panino: Panino, allPanini: [Panino], user: UserModel) {
        assert(Thread.isMainThread, "update deve essere chiamato sul main thread")
        let paniniNotInTrash = allPanini.filter { !$0.inTrash }
        print("UPDATE")
        
        let oldPoints = panino.points
        panino.refreshBadges(using: allPanini)
        let newPoints = panino.calculatePoints()
        
        print("allPanini: \(allPanini.map { ($0.name, $0.points) })")
        print("panino: \(panino.name) \(panino.points)")
        print("panini not in trash: \(paniniNotInTrash.map { ($0.name, $0.points) })")
        
        // Aggiorna sempre i punti del panino
        panino.points = panino.inTrash ? 0 : newPoints

        // Ricalcola il totale dei punti da panini attivi
        let totalPoints = allPanini.map { $0.points }.reduce(0, +)
        
        // Aggiorna l'utente solo se necessario
        if user.pex != totalPoints {
            user.pex = totalPoints
            user.level = user.pex / UserGamifications.pointsPerLevelUp
            user.saveUserData()
        }

        print("newPoints: \(newPoints) - oldPoints: \(oldPoints) = delta: \(newPoints - oldPoints)")
        print("user: \(user.pex) == total points: \(totalPoints) ? \(user.pex == totalPoints)")
    }
    
    func recalculateAll(panini: [Panino], user: UserModel) {
        for panino in panini {
            panino.refreshBadges(using: panini)
            panino.points = panino.inTrash ? 0 : panino.calculatePoints()
        }

        let totalPoints = panini.map { $0.points }.reduce(0, +)
        if user.pex != totalPoints {
            user.pex = totalPoints
            user.level = user.pex / UserGamifications.pointsPerLevelUp
            user.saveUserData()
        }

        print("recalculated total points: \(totalPoints), user.pex: \(user.pex), match: \(user.pex == totalPoints)")
    }
}
