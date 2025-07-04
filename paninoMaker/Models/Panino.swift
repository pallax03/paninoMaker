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

enum PaninoGamifications {
    static let pointsPerImage: Int = 4
    static let pointsPerRating: Int = 1
    static let pointsPerDescription: Int = 2
    static let pointsPerMap: Int = 5
    static let pointsPerIngredients: Int = 2
}

@Model
class Panino {
    // MARK: - Properties
    var id = UUID()
    var name: String
    var isSaved: Bool = false
    var inTrash: Bool = false
    var creationDate: Date = Date()
    var badges: [BadgeEntity] = []
    var owner: String?
    var latitude: Double?
    var longitude: Double?
    var imageData: [Data]
    var rating: Int? = nil
    var ratingDescription: String? = nil
    var composer: Composer
    var menu: MenuModel?
    var pex = 0
    
    // MARK: - Computed
    
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
        composer: Composer = .init(),
        menu: MenuModel? = nil,
        coordinates: CLLocationCoordinate2D? = nil,
        images: [UIImage] = [],
    ) {
        self.name = name
        self.owner = owner
        self.composer = composer
        self.menu = menu
        self.latitude = coordinates?.latitude
        self.longitude = coordinates?.longitude
        self.imageData = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
    }
    
    // MARK: - Utilities
    func addImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            self.imageData.append(data)
        }
    }
    
    func resetImages() {
        self.imageData.removeAll()
    }
    
    func resetComposer() {
        self.composer = Composer()
    }
    
    func resetRating() {
        self.rating = nil
        self.ratingDescription = nil
    }
    
    func resetMap() {
        self.latitude = nil
        self.longitude = nil
    }
    
    func resetPanino() {
        resetImages()
        resetComposer()
        resetRating()
        resetMap()
    }
    
    func setCoordinates(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    func updatePanino(_ panino: Panino) {
        self.name = panino.name
        self.owner = panino.owner
        self.latitude = panino.latitude
        self.longitude = panino.longitude
        self.imageData = panino.imageData
        self.rating = panino.rating
        self.ratingDescription = panino.ratingDescription
        self.composer = panino.composer
        self.menu = panino.menu
    }
    
    func sendToTrash() {
        self.inTrash = true
        self.menu = nil
    }
    
    func restoreFromTrash(menu: MenuModel?) {
        self.inTrash = false
        self.menu = menu
    }
    
    // MARK: - Gamifications
    func calculatePoints() -> Int {
        var points: Int = 0
        
        self.composer.ingredients.forEach { _ in points += PaninoGamifications.pointsPerIngredients }
        self.images.forEach { _ in points += PaninoGamifications.pointsPerImage }
        if self.rating != nil { points += PaninoGamifications.pointsPerRating }
        if self.ratingDescription != nil { points += PaninoGamifications.pointsPerDescription }
        if self.coordinates != nil { points += PaninoGamifications.pointsPerMap }
        
        let divisor = pow(10.0, 2.0)
        let mult = (badges.map{ $0.mult }.reduce(1.0, +) * divisor).rounded() / divisor
        
        self.pex = Int(Double(points) * mult)
        return self.pex
    }
    
    func refreshBadges(using allPanini: [Panino]) {
        var newBadges: [BadgeEntity] = []
        for badge in BadgesLibrary.all where badge.isEligible(for: self, in: allPanini) {
            newBadges.append(badge.entity())
        }
        self.badges = newBadges
    }
}
