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
    case vegan, veg, gluten, dairy, fat, spicy
}

enum IngredientCategory: String, Codable, CaseIterable {
    case buns, meats, vegetables, toppings, sauces
    
    var displayName: String {
            switch self {
            case .buns: return "Pane"
            case .meats: return "Carne"
            case .vegetables: return "Verdure"
            case .toppings: return "Extra"
            case .sauces: return "Salse"
            }
        }
    
    var color: Color {
            switch self {
            case .buns: return .yellow
            case .meats: return .brown
            case .vegetables: return .green
            case .toppings: return .indigo
            case .sauces: return .red
            }
        }
}
