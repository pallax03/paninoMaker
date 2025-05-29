//
//  PreviewData.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import Foundation
import SwiftData

enum PreviewData {
    static let samplePanini: [Panino] = [
        Panino(
            name: "Hamburger",
            owner: "Preview User",
            ingredients: IngredientStore().generateRandoms(count: 1)
        ),
        Panino(
            name: "CheeseBurger",
            owner: "Preview User",
            ingredients: IngredientStore().generateRandoms(count: 3)
        ),
        Panino(
            name: "Bacon Burger",
            owner: "Preview User",
            ingredients: IngredientStore().generateRandoms(count: 5)
        )
    ]

    static func makeModelContainer(
        for entities: [any PersistentModel.Type] = [Panino.self],
        withSampleData: Bool = true
    ) -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let schema = Schema(entities)
    let container = try! ModelContainer(for: schema, configurations: config)
    
    if withSampleData {
        let modelContext = ModelContext(container)
        for panino in samplePanini {
            modelContext.insert(panino)
        }
        try! modelContext.save()
        
    }
    
    return container
    }
}
