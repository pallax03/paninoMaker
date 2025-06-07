//
//  IngredientStore.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import Foundation
import SwiftUICore

final class IngredientStore {
    private(set) var ingredients: [Ingredient] = []
    
    init() {
        ingredients = decodeJSON("ingredients")
    }
    
    func ingredient(withID id: String) -> Ingredient? {
        ingredients.first(where: { $0.id == id })
    }
    
    func ingredients(wantedLevel: Int)-> [Ingredient] {
        ingredients.filter { $0.unlockLevel == wantedLevel }
    }
    
    func firstBun() -> Ingredient? {
        ingredients(ofCategory: IngredientCategory.buns).first
    }
    
    func ingredients(ofCategory category: IngredientCategory) -> [Ingredient] {
        ingredients.filter({ $0.category == category })
    }
    
    func search(name: String) -> Ingredient? {
        ingredients.first(where: {$0.name == name})
    }
    
    func random(category: IngredientCategory? = nil) -> Ingredient? {
        category != nil ? ingredients(ofCategory: category!).randomElement() : ingredients.randomElement()
    }
    
    func generateRandoms(count: Int) -> [Ingredient] {
        (0..<count).compactMap { _ in
            ingredients.randomElement()
        }
    }
}

struct IngredientStoreKey: EnvironmentKey {
    static let defaultValue: IngredientStore = IngredientStore()
}

extension EnvironmentValues {
    var ingredientStore: IngredientStore {
        get { self[IngredientStoreKey.self] }
        set { self[IngredientStoreKey.self] = newValue }
    }
}

