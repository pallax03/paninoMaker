//
//  IngredientsView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import SwiftUI

struct IngredientsView: View {
    var ingredients: [Ingredient] = decodeJSON("ingredients")
    
    var body: some View {
        List {
            ForEach(groupedIngredients.keys.sorted(), id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(groupedIngredients[category] ?? []) { ingredient in
                        
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text(ingredient.name)
                                Text(ingredient.tags.joined(separator: " - "))
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            Spacer()
                            Text(ingredient.unlockLevel)
                        }
                    }
                }
            }
        }
    }

    var groupedIngredients: [String: [Ingredient]] {
        Dictionary(grouping: ingredients, by: { $0.category })
    }
}


#Preview {
    IngredientsView()
}
