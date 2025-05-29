//
//  Panino.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import CoreLocation
import SwiftUI
import SwiftData

@Model
class Panino: Identifiable, ObservableObject {
    // MARK: - Properties
    var id: UUID
    var name: String
    var isFavorite: Bool
    var creationDate: Date
    var owner: String?
    var latitude: Double?
    var longitude: Double?
    var imageData: [Data] = []
    var rating: Int?
    var ratingDescription: String?
    
    var ingredients: [Ingredient]
    
//    @Relationship
//    var badges: [Badge] = []
    
    // MARK: - Computed
    var displayName: String {
        name.isEmpty ? "Panino #\(id.uuidString.prefix(5))" : name
    }
    
    var images: [UIImage] {
        imageData.compactMap { UIImage(data: $0) }
    }
    
    var coordinates: CLLocationCoordinate2D? {
        guard let latitude, let longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
        self.isFavorite = false
        self.creationDate = Date()
        self.owner = owner

        // Gestione coordinate
        self.latitude = coordinates?.latitude
        self.longitude = coordinates?.longitude

        // Gestione immagini
        self.imageData = images.compactMap { $0.jpegData(compressionQuality: 0.8) }

        self.rating = rating
        self.ratingDescription = ratingDescription
        self.ingredients = ingredients
    }
    
    // MARK: - Utilities
    func addImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            imageData.append(data)
        }
    }
    
    func setCoordinates(_ coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
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
    func calculatePoints() -> Int {
        var points: Int = 0
        
        images.forEach { _ in points += PaninoGamifications.pointsPerImage }
        if rating != nil { points += PaninoGamifications.pointsPerRating }
        if ratingDescription != nil { points += PaninoGamifications.pointsPerDescription }
        if coordinates != nil { points += PaninoGamifications.pointsPerMap }
        
//        return Int(Double(points) * badges.reduce(1.0) { $0 * $1.mult })
        return points
    }
}
