//
//  ComposerIngredients.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 10/06/25.
//

import SwiftUI

struct ComposerIngredients: View {
    @Binding var draftComposer: [Ingredient]
    @State private var isShown = false
    @Environment(\.ingredientStore) var ingredientStore
    
    var body: some View {
        if !draftComposer.isEmpty {
            List {
                ForEach($draftComposer) { ingredient in
                    ZStack {
                        if let img = UIImage(named: ingredient.wrappedValue.imageName) {
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
                        
                        VStack {
                            
                            Text(ingredient.wrappedValue.name)
                                .font(.title)
                            
                            Text(ingredient.wrappedValue.tags.map { $0.rawValue.capitalized }.joined(separator: ", "))
                                .font(.caption)
                        }
                        .foregroundStyle(.white)
                    }
                    .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
                    .contextMenu {
                        Button("Delete ingredient", role: .destructive) {
                            if let index = draftComposer.firstIndex(of: ingredient.wrappedValue) {
                                draftComposer.remove(at: index)
                            }
                        }
                    }
                    .offset(y: -8)
                }
                .onMove { indices, newOffset in
                    draftComposer.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .environment(\.editMode, .constant(.active))
        }
        
        Button {
            isShown.toggle()
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .tint(.yellow)
        }
        .sheet(isPresented: $isShown) {
            NavigationStack {
                IngredientList(ingredients: ingredientStore.ingredients,
                               onIngredientSelected: { ingredient in
                    draftComposer.append(ingredient)
                })
                .navigationTitle("Ingredients")
            }
        }
    }
}

#Preview {
    ComposerIngredients(draftComposer: .constant(Composer().ingredients))
        .environmentObject(UserModel())
        .modelContainer(PreviewData.makeModelContainer())
}
