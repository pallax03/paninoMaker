//
//  PreviewData.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import Foundation
import SwiftData

enum PreviewData {
    static let samplePanino: [Panino] = [
        Panino(
            name: "Hamburger",
            owner: "Preview User",
            composer: Composer(ingredients: IngredientStore().generateRandoms(count: 10))
        )
    ]
    
    static let samplePanini: [Panino] = [
        Panino(
            name: "CheeseBurger",
            owner: "Preview User",
            composer: Composer(ingredients: IngredientStore().generateRandoms(count: 3))
        ),
        Panino(
            name: "Bacon Burger",
            owner: "Preview User",
            composer: Composer(ingredients: IngredientStore().generateRandoms(count: 5))
        )
    ]
    
    static let sampleMenus: [Menu] = [
        Menu(title: "Preview Menu 1", panini: samplePanino),
        Menu(title: "Preview Menu 2", panini: samplePanini)
    ]

    static func makeModelContainer(
        for entities: [any PersistentModel.Type] = [Menu.self],
        withSampleData: Bool = true
    ) -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let schema = Schema(entities)
    let container = try! ModelContainer(for: schema, configurations: config)
    
    if withSampleData {
        let modelContext = ModelContext(container)
        for menu in sampleMenus {
            modelContext.insert(menu)
        }
        try! modelContext.save()
        
    }
    
    return container
    }
}
