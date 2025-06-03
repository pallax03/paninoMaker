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
    @Binding var composer: Composer
    @State var draftComposer: Composer
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Bread(draftComposer: $draftComposer.top)
                    
                    if !draftComposer.ingredients.isEmpty {
                        ForEach(draftComposer.ingredients) { ingredient in
                            ZStack {
                                if let img = UIImage(named: ingredient.imageName) {
                                    Image(uiImage: img)
                                    .resizable()
                                    .frame(width: 300, height: 80)
                                    .cornerRadius(10)
                                } else {
                                    Rectangle()
                                    .fill(.green)
                                    .frame(width: 300, height: 80)
                                    .cornerRadius(10)
                                }
                                
                                Text(ingredient.name)
                                    .foregroundStyle(.white)
                                    .font(.title)
                            }
                            .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
                            .contextMenu {
                                Button("Delete ingredient", role: .destructive) {
                                    // Deleting Task
                                    draftComposer.ingredients.removeAll { $0.id == ingredient.id }
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
                                draftComposer.ingredients.append(ingredient)
                            })
                            .navigationTitle("Ingredients")
                        }
                    }
                    
                    Bread(draftComposer: $draftComposer.bottom)
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
                            composer = draftComposer
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
    @Binding var draftComposer: Ingredient
    
    var body: some View {
        Button {
            isShownBread = true
        } label: {
            ZStack {
                Image(draftComposer.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: .infinity, height: 80)
                .cornerRadius(10)
                .padding()
                
                Text(draftComposer.name)
            }
            .foregroundStyle(.white)
            .font(.title)
        }
        .sheet(isPresented: $isShownBread) {
            NavigationStack {
                IngredientList(
                    ingredients: ingredientStore.ingredients(ofCategory: IngredientCategory.buns),
                    onIngredientSelected: { ingredient in
                        draftComposer = ingredient
                })
                .navigationTitle("Ingredients")
            }
        }
    }
}

#Preview {
    ComposerSheet(composer: .constant(Composer()), draftComposer: Composer())
        .environmentObject(UserModel())
}
