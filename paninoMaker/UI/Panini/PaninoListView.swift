//
//  paninoListView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI
import SwiftData

struct PaninoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var panini: [Panino]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(panini) { panino in
                    VStack(alignment: .leading) {
                        NavigationLink(
                            destination: IngredientsView(
                                ingredients: panino.ingredients,
                                onSelect: { ingredient in
                                    print("show \(ingredient.name)")
                                }
                            )
                        ) {
                            PaninoRowView(panino: panino)
                        }
                    }
                }
            }
            .navigationTitle("'Menu' Panini")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        let panino = Panino(
                            name: "Panino \(panini.count+1)",
                            ingredients: IngredientStore().generateRandoms(count: Int.random(in: 1...10))
                        )
                        modelContext.insert(panino)
                    }) {
                        Label("Add panino", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    PaninoListView().modelContainer(PreviewData.makeModelContainer(withSampleData: true)).environmentObject(UserModel())
}
