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
        let grouped = Dictionary(grouping: ingredients, by: \.category)
        return IngredientCategory.allCases.compactMap { category in grouped[category].map { (category, $0) } }
    }
    @State private var collapsedCategories: Set<IngredientCategory> = []

    var body: some View {
        List {
            ForEach(groupedIngredients, id: \.key) { category, ingredients in
                Section {
                    if !collapsedCategories.contains(category) {
                        ForEach(ingredients) { ingredient in
                            IngredientRow(ingredient: ingredient, onSelect: onIngredientSelected)
                                .contentShape(Rectangle())
                                .listRowBackground(ingredient.category.color.opacity(0.05))
                        }
                    }
                } header: {
                    Button {
                        withAnimation {
                            if collapsedCategories.contains(category) {
                                collapsedCategories.remove(category)
                            } else {
                                collapsedCategories.insert(category)
                            }
                        }
                    } label: {
                        ZStack {
                            category.color.opacity(0.2)
                            HStack(spacing: 0) {
                                Text(category.displayName)
                                    .font(.title)
                                    .foregroundStyle(category.color)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                Spacer()
                                Image(systemName: collapsedCategories.contains(category) ? "chevron.down" : "chevron.up")
                                    .padding(.trailing, 16)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
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
