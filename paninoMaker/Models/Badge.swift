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
    func defaultView(icon: String) -> AnyView {
        AnyView(
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .padding(15)
                .background(color.opacity(0.2))
                .clipShape(Circle())
        )
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
        HeartBadge(),
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

struct HeartBadge: Badge {
    var title: String = "Heart"
    var description: String = "Your Saved Paninos"
    var color: Color = .red
    var mult: Double = 1.2
    var view: AnyView {
        defaultView(icon: "bookmark.fill")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.isSaved
    }
}

struct VeganBadge: Badge {
    var title: String = "100% Vegan 🌱"
    var description: String = "For the Earth"
    var color: Color = .green
    var mult: Double = 2.0
    var view: AnyView {
        defaultView(icon: "heart.fill")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.allSatisfy {$0.tags.contains(.vegan)}
    }
}

struct VegetarianBadge: Badge {
    var title: String = "100% Vegetarian 🌿"
    var description: String = "For the Animals"
    var color: Color = .purple
    var mult: Double = 1.9
    var view: AnyView {
        defaultView(icon: "heart.fill")
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
        defaultView(icon: "heart.fill")
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
        defaultView(icon: "heart.fill")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.allSatisfy {!$0.tags.contains(.dairy)}
    }
}

struct BigPortionBadge: Badge {
    var title: String = "BIGGGGG"
    var description: String = "Non ti annoierai più con i prezzi!"
    var color: Color = .orange
    var mult: Double = 1.1
    var view: AnyView {
        defaultView(icon: "heart.fill")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.count >= allPanini.map({$0.composer.ingredients.count}).max() ?? 0
    }
}

struct SmallPortionBadge: Badge {
    var title: String = "MINI SIZE"
    var description: String = "Mi hanno prescritto una gastroscopia 😅"
    var color: Color = .gray
    var mult: Double = 1.6
    var view: AnyView {
        defaultView(icon: "heart.fill")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.count <= allPanini.map({$0.composer.ingredients.count}).min() ?? 0
    }
}

struct HealthyBadge: Badge {
    var title: String = "Healthy"
    var description: String = "Try finger but hole"
    var color: Color = .green
    var mult: Double = 1.7
    var view: AnyView {
        defaultView(icon: "heart.fill")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.allSatisfy {!$0.tags.contains(.fat)}
    }
}

struct SpicyBadge: Badge {
    var title: String = "BURN IT"
    var description: String = "Non mi piace il piccante!"
    var color: Color = .red
    var mult: Double = 1.2
    var view: AnyView {
        defaultView(icon: "heart.fill")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        return panino.composer.ingredients.contains(where: {$0.tags.contains(.spicy)})
    }
}

struct TheChosenOne: Badge {
    var title: String = "CHOSEN ONE"
    var description: String = "Il più vecchio è il migliore!"
    var color: Color = .pink
    var mult: Double = 1.1
    var view: AnyView {
        defaultView(icon: "heart.fill")
    }
    func isEligible(for panino: Panino, in allPanini: [Panino]) -> Bool {
        guard let primo = allPanini.min(by: { $0.creationDate < $1.creationDate }) else {
            return false
        }
        return primo === panino
    }
}
