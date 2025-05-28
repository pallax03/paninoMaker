//
//  Badge.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import Foundation
import SwiftUI


class Badge {
    var name: String
    var view: any View
    var color: Color
    let multiplier: CGFloat
    
    init(name: String, view: some View, color: Color, multiplier: CGFloat) {
        self.name = name
        self.view = view
        self.color = color
        self.multiplier = multiplier
    }
}

//
//enum Badges {
//    static let heart: Badge = .init(
//        name: "heart",
//        view: Image(systemName: "heart.fill"),
//        color: .red,
//        multiplier: 1.2
//    )
//
//}
//
//
//enum Badges: String, CaseIterable {
//    vegan = "vegan"
//    glutenFree = "gluten-free"
//    dairyFree = "dairy-free"
//    vegetarian = "vegetarian"
//    bigPortion = "big-portion"
//    smallPortion = "small-portion"
//}
