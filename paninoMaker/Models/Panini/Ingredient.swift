//
//  Ingredient.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import SwiftUI

struct Ingredient: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var imageName: String
    var category: IngredientCategory
    var tags: Set<IngredientTag>
    var unlockLevel: Int
}


enum IngredientTag: String, Codable {
    case vegan, veg, egg, dairy, gluten, fat, spicy
}

enum IngredientCategory: String, Codable {
    case buns, meats, vegetables, toppings, sauces
}
