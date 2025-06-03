//
//  PreviewData.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import Foundation
import SwiftData
import CoreLocation

enum PreviewData {
    static let samplePanino: Panino =
    Panino(
        name: "Hamburger",
        owner: "Preview User",
        composer: Composer(ingredients: IngredientStore().generateRandoms(count: 10)),
        coordinates: CLLocationCoordinate2D(latitude: 44.1483115, longitude: 12.2357904)
    )
    
    static let samplePanini: [Panino] = [
        Panino(
            name: "CheeseBurger",
            owner: "Preview User",
            composer: Composer(ingredients: IngredientStore().generateRandoms(count: 3)),
            coordinates: CLLocationCoordinate2D(latitude: 37.334606, longitude: -122.009102)
        ),
        Panino(
            name: "Bacon Burger",
            owner: "Preview User",
            composer: Composer(ingredients: IngredientStore().generateRandoms(count: 5)),
            coordinates: CLLocationCoordinate2D(latitude: 44.067547, longitude: 12.5788244)
        )
    ]
    
    static let sampleMenu: Menu = Menu(title: "Preview Menu 1", panini: samplePanini)
    
    static let sampleMenus: [Menu] = [
        sampleMenu,
        Menu(title: "Preview Menu 2", panini: [samplePanino])
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
