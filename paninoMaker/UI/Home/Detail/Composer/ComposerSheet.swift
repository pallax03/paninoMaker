//
//  ComposerSheet.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct ComposerSheet: View {
    @Environment(\.ingredientStore) var ingredientStore
    @Environment(\.dismiss) private var dismiss
    @State private var isShown = false
    @State private var ingredientList: [Ingredient] = []
    @Binding var panino: Panino?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Bread(ingredientList: $ingredientList)
                    
                    if !ingredientList.isEmpty {
                        ForEach(ingredientList) { ingredient in
                            ZStack {
                                Rectangle()
                                    .fill(.green)
                                    .frame(width: 300, height: 80)
                                    .cornerRadius(10)
                                
                                Text(ingredient.name)
                            }
                            .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
                            .contextMenu {
                                Button("Delete ingredient", role: .destructive) {
                                    // Deleting Task
                                    ingredientList.removeAll { $0.id == ingredient.id }
                                }
                            }
                            .offset(y: -8)
                        }
                    }
                    
                    Button {
                        isShown = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .sheet(isPresented: $isShown) {
                        NavigationStack {
                            IngredientList(ingredients: ingredientStore.ingredients,
                                onIngredientSelected: { ingredient in
                                ingredientList.append(ingredient)
                            })
                            .navigationTitle("Ingredients")
                        }
                    }
                    
                    Bread(ingredientList: $ingredientList)
                }
                .padding()
                .navigationTitle("Panino #N")
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            // Chiude lo sheet
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // Fare qualcosa poi chiudere lo sheet
                            dismiss()
                        } label: {
                            Text("Save")
                        }
                    }
                }
            }
        }
    }
}

struct Bread: View {
    @Environment(\.ingredientStore) var ingredientStore
    @State private var isShownBread = false
    @Binding var ingredientList: [Ingredient]
    
    var body: some View {
        Button {
            isShownBread = true
        } label: {
            Rectangle()
                .fill(.brown)
                .frame(width: .infinity, height: 80)
                .cornerRadius(10)
                .padding()
        }
        .sheet(isPresented: $isShownBread) {
            NavigationStack {
                IngredientList(
                    ingredients: ingredientStore.ingredients(ofCategory: IngredientCategory.buns),
                    onIngredientSelected: { ingredient in
                        ingredientList.append(ingredient)
                })
                .navigationTitle("Ingredients")
            }
        }
    }
}

#Preview {
    ComposerSheet(panino: .constant(nil))
        .environmentObject(UserModel())
}
