//
//  Composer.swift
//  paninoMaker
//
//  Created by alex mazzoni on 29/05/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Composer {
    var top: Ingredient
    var ingredients: [Ingredient]
    var bottom: Ingredient
    
    init(
        top: Ingredient = IngredientStore().firstBun()!,
        ingredients: [Ingredient] = [],
        bottom: Ingredient = IngredientStore().firstBun()!,
    ) {
        self.top = top
        self.ingredients = ingredients
        self.bottom = bottom
    }

    func setTop(_ ingredient: Ingredient) {
        guard ingredient.category == IngredientCategory.buns else { return }
        self.top = ingredient
    }
    
    func setBottom(_ ingredient: Ingredient) {
        guard ingredient.category == IngredientCategory.buns else { return }
        self.bottom = ingredient
    }
    
    func addIngredient(_ ingredient: Ingredient) {
        ingredients.append(ingredient)
    }
    
    func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
    
    func searchIngredient(by name: String) -> Ingredient? {
        ingredients.first { $0.name == name }
    }
}
