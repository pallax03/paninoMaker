//
//  IngredientsView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import SwiftUI

struct IngredientsView: View {
    var ingredients: [Ingredient] = []
    
    var groupedIngredients: [(key: String, value: [Ingredient])] {
        Dictionary(grouping: ingredients, by: \.category)
            .sorted(by: { $0.key < $1.key })
    }

    var body: some View {
        List {
            ForEach(groupedIngredients, id: \.key) { category, ingredients in
                Section(header: Text(category)) {
                    ForEach(ingredients) { ingredient in
                        IngredientRowView(ingredient: ingredient)
                    }
                }
            }
        }
    }
}


#Preview {
    let ingredients = IngredientStore().ingredients
    IngredientsView(ingredients: ingredients).environmentObject(UserModel())
}
