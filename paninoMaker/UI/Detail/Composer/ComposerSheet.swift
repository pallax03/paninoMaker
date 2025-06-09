//
//  ComposerSheet.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData

struct ComposerSheet: View {
    @EnvironmentObject var user: UserModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.ingredientStore) var ingredientStore
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Environment(\.dismiss) private var dismiss
    @State private var isShown = false
    @Binding var panino: Panino
    @State var draftComposer: Composer
    
    var body: some View {
        NavigationStack {
            VStack {
                Bread(draftComposer: $draftComposer.top)
                
                if !draftComposer.ingredients.isEmpty {
                    List {
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
                                
                                VStack {
                                    
                                    Text(ingredient.name)
                                        .font(.title)
                                    
                                    Text(ingredient.tags.map { $0.rawValue.capitalized }.joined(separator: ", "))
                                        .font(.caption)
                                }
                                .foregroundStyle(.white)
                            }
                            .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
                            .contextMenu {
                                Button("Delete ingredient", role: .destructive) {
                                    if let index = draftComposer.ingredients.firstIndex(of: ingredient) {
                                        draftComposer.ingredients.remove(at: index)
                                    }
                                }
                            }
                            .offset(y: -8)
                        }
                        .onMove { indices, newOffset in
                            draftComposer.ingredients.move(fromOffsets: indices, toOffset: newOffset)
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .environment(\.editMode, .constant(.active))
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
                        panino.composer = draftComposer
                        GamificationManager.shared.recalculateAll(panini: allPanini)
                        try? modelContext.save()
                        dismiss()
                    } label: {
                        Text("Save")
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
    ComposerSheet(panino: .constant(Panino()), draftComposer: Composer())
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
}
