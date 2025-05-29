//
//  Config.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

enum UserGamifications {
    static let enableGamification: Bool = false
    static let levelCap = 5
    static let pointsPerLevelUp: Int = 100
}

enum PaninoGamifications {
    static let pointsPerImage: Int = 4
    static let pointsPerRating: Int = 1
    static let pointsPerDescription: Int = 2
    static let pointsPerMap: Int = 5
}

enum BadgesLibrary {
    static let all: [Badge] = [
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
}
