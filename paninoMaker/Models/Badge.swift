//
//  Badge.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import Foundation
import SwiftUI
import SwiftData

protocol Badge: Hashable {
    var title: String { get }
    var description: String { get }
    var color: Color { get }
    var mult: Double { get }
    var view: AnyView { get }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool
}

extension Badge {
    func defaultView(text: String) -> AnyView {
        return AnyView(Text(text))
    }
    func entity() -> BadgeEntity {
        BadgeEntity(title: title, mult: mult)
    }
}

@Model
class BadgeEntity {
    var title: String
    var mult: Double
    
    init(title: String, mult: Double) {
        self.title = title
        self.mult = mult
    }
    
    // Collegamento logico con la libreria badge
    var resolvedBadge: (any Badge)? {
        BadgesLibrary.all.first(where: { $0.title == self.title })
    }
}

enum BadgesLibrary {
    static let all: [any Badge] = [
        BunBadge(),
        VeganBadge(),
        VegetarianBadge(),
        GlutenFreeBadge(),
        DairyFreeBadge(),
        BigPortionBadge(),
        SmallPortionBadge(),
        HealthyBadge(),
        SpicyBadge(),
        TheChosenOne()
    ]
    
    static func randomBadges(count: Int?) -> Set<BadgeEntity> {
        let allBadges = BadgesLibrary.all.shuffled()
        let limit = min(count ?? Int.random(in: 1...allBadges.count), allBadges.count)
        return Set(allBadges.prefix(limit).map { $0.entity() })
    }
}

struct BunBadge: Badge {
    var title: String = "SOLO PANE"
    var description: String = "Ai tempi della guerra!"
    var color: Color = .orange
    var mult: Double = 2.4
    var view: AnyView {
        defaultView(text: "🍞")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.allSatisfy({ $0.category == .buns })
    }
}

struct VeganBadge: Badge {
    var title: String = "100% Vegano"
    var description: String = "Sei un erbivoro"
    var color: Color = .green
    var mult: Double = 2.0
    var view: AnyView {
        defaultView(text: "🌱")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.allSatisfy {$0.tags.contains(.vegan)}
    }
}

struct VegetarianBadge: Badge {
    var title: String = "100% Vegetariano"
    var description: String = "Salvi gli animali ma uccidi le grigliate..."
    var color: Color = .teal
    var mult: Double = 1.9
    var view: AnyView {
        defaultView(text: "🥬")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.allSatisfy {$0.tags.contains(.veg)}
    }
}

struct GlutenFreeBadge: Badge {
    var title: String = "Gluten Free"
    var description: String = "Tu sei come superman, hai i super poteri!"
    var color: Color = .yellow
    var mult: Double = 1.4
    var view: AnyView {
        defaultView(text: "🌾")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.allSatisfy {!$0.tags.contains(.gluten)}
    }
}

struct DairyFreeBadge: Badge {
    var title: String = "No Lattosio"
    var description: String = "Rispettiamo le mucche 🐮"
    var color: Color = .blue
    var mult: Double = 1.5
    var view: AnyView {
        defaultView(text: "🥛")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.allSatisfy {!$0.tags.contains(.dairy)}
    }
}

struct BigPortionBadge: Badge {
    var title: String = "BIGGGGG"
    var description: String = "Guinness World Record!"
    var color: Color = .indigo
    var mult: Double = 1.1
    var view: AnyView {
        defaultView(text: "🦖")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.count >= allPanini.map({$0.composer.ingredients.count}).max() ?? 0
    }
}

struct SmallPortionBadge: Badge {
    var title: String = "MINI SIZE"
    var description: String = "Le dimensioni non contano"
    var color: Color = .cyan
    var mult: Double = 1.6
    var view: AnyView {
        defaultView(text: "🪶")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.count <= allPanini.map({$0.composer.ingredients.count}).min() ?? 0
    }
}

struct HealthyBadge: Badge {
    var title: String = "FAT"
    var description: String = "In Romagna si chiama Baghino"
    var color: Color = .brown
    var mult: Double = 1.7
    var view: AnyView {
        defaultView(text: "🐷")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.contains {$0.tags.contains(.fat)}
    }
}

struct SpicyBadge: Badge {
    var title: String = "BURN IT"
    var description: String = "Caldo come il Sole"
    var color: Color = .red
    var mult: Double = 1.2
    var view: AnyView {
        defaultView(text: "🌶️")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.contains(where: {$0.tags.contains(.spicy)})
    }
}

struct TheChosenOne: Badge {
    var title: String = "CHOSEN ONE"
    var description: String = "Il veterano"
    var color: Color = .pink
    var mult: Double = 1.1
    var view: AnyView {
        defaultView(text: "👑")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        guard let primo = allPanini.min(by: { $0.creationDate < $1.creationDate }) else {
            return false
        }
        return primo === panino
    }
}
