//
//  Panino.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import CoreLocation
import SwiftUI


class Panino: Identifiable, ObservableObject {
    // MARK: - Properties
    
    let id: UUID
    @Published var name: String
    let creationDate: Date
    @Published var owner: String? // nil se anonimo
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var images: [UIImage] // oppure Data per CloudKit compatibilità
    @Published var rating: Int?
    @Published var ratingDescription: String?
    @Published var ingredients: [Ingredient]
    var badges: [Badge] = []
    
    // MARK: - Computed
    var displayName: String {
        name.isEmpty ? "Panino #\(id.uuidString.prefix(5))" : name
    }
    
    // MARK: - Init
    init(
        name: String = "",
        owner: String? = nil,
        coordinates: CLLocationCoordinate2D? = nil,
        images: [UIImage] = [],
        rating: Int? = nil,
        ratingDescription: String? = nil,
        ingredients: [Ingredient] = []
    ) {
        self.id = UUID()
        self.name = name
        self.creationDate = Date()
        self.owner = owner
        self.coordinates = coordinates
        self.images = images
        self.rating = rating
        self.ratingDescription = ratingDescription
        self.ingredients = ingredients
    }
    
    // MARK: - Ingredients
    func addIngredient(_ ingredient: Ingredient) {
        ingredients.append(ingredient)
    }
    
    func removeIngredient(at index: Int) {
        ingredients.remove(at: index)
    }
    
    func searchIngredient(by name: String) -> Ingredient? {
        ingredients.first { $0.name == name }
    }
    
    // MARK: - Gamifications
    func getPoints() -> Int {
        var points: Int = 0
        
        images.forEach { _ in points += 4 }
        if rating != nil { points += 1 }
        if ratingDescription != nil { points += 2 }
        if coordinates != nil { points += 5 }
        
        
        return points
    }
}
