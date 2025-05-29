//
//  Ingredient.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import SwiftUI

struct Ingredient: Codable, Identifiable {
    var id: String
    var name: String
    var imageName: String
    var category: String
    var tags: Set<IngredientTag>
    var unlockLevel: Int
}


enum IngredientTag: String, Codable {
    case vegan, veg, egg, dairy, gluten, fat, spicy
}
