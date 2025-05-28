//
//  IngredientsView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import SwiftUI

struct IngredientsView: View {
    @Environment(\.ingredientStore) var ingredientStore
    var groupedIngredients: [(key: String, value: [Ingredient])] {
        Dictionary(grouping: ingredientStore.ingredients, by: \.category)
            .sorted(by: { $0.key < $1.key })
    }

    var body: some View {
        List {
            ForEach(groupedIngredients, id: \.key) { category, ingredients in
                Section(header: Text(category)) {
                    ForEach(ingredients) { ingredient in
                        IngredientRow(ingredient: ingredient)
                    }
                }
            }
        }
    }
}


#Preview {
    IngredientsView().environmentObject(UserModel())
}
