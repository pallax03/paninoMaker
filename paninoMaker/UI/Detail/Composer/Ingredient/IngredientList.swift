//
//  IngredientList.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import SwiftUI

struct IngredientList: View {
    var ingredients: [Ingredient] = []
    var onIngredientSelected: (Ingredient) -> Void
    var groupedIngredients: [(key: IngredientCategory, value: [Ingredient])] {
        Dictionary(grouping: ingredients, by: \.category)
            .sorted(by: { $0.key.rawValue < $1.key.rawValue })
    }

    var body: some View {
        List {
            ForEach(groupedIngredients, id: \.key) { category, ingredients in
                Section(header: Text(category.rawValue.capitalized)) {
                    ForEach(ingredients) { ingredient in
                        IngredientRow(ingredient: ingredient, onSelect: onIngredientSelected)
                            .contentShape(Rectangle())                    }
                }
            }
        }
    }
}

#Preview {
    IngredientList(
        ingredients: IngredientStore().ingredients,
        onIngredientSelected: { ingredient in
            print("Preview selected: \(ingredient.name)")
        }
    )
    .environmentObject(UserModel())
}
