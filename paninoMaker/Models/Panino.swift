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
class Panino {
    // MARK: - Properties
    var name: String
    var isSaved: Bool
    var creationDate: Date
    var owner: String?
    var latitude: Double?
    var longitude: Double?
    var imageData: [Data]
    var rating: Int?
    var ratingDescription: String?
    var composer: Composer
    var menu: Menu?
    var inTrash: Bool
    var badges: [BadgeEntity]
    
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
        coordinates: CLLocationCoordinate2D? = nil,
        images: [UIImage] = [],
        rating: Int? = nil,
        ratingDescription: String? = nil,
        composer: Composer = .init(),
        menu: Menu? = nil,
        badges: [BadgeEntity] = []
    ) {
        self.name = name
        self.isSaved = false
        self.inTrash = false
        self.creationDate = Date()
        self.owner = owner
        
        // Gestione coordinate
        self.latitude = coordinates?.latitude
        self.longitude = coordinates?.longitude
        
        // Gestione immagini
        self.imageData = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
        
        self.rating = rating
        self.ratingDescription = ratingDescription
        
        self.composer = composer
        self.menu = menu
        
        self.badges = Array(Set(badges))
    }
    
    // MARK: - Utilities
    func addImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            imageData.append(data)
        }
    }
    
    func resetImages() {
        imageData.removeAll()
    }
    
    func setCoordinates(_ coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
    
    // MARK: - Gamifications
    func calculatePoints() -> Int {
        var points: Int = 0
        
        images.forEach { _ in points += PaninoGamifications.pointsPerImage }
        if rating != nil { points += PaninoGamifications.pointsPerRating }
        if ratingDescription != nil { points += PaninoGamifications.pointsPerDescription }
        if coordinates != nil { points += PaninoGamifications.pointsPerMap }
        
        return Int(Double(points) * badges.map{ $0.mult }.reduce(1.0, *))
    }
    
//    func refreshBadges(using allPanini: [Panino]) {
//            let allBadges = BadgesLibrary.all
//            var newBadges: Set<BadgeEntity> = []
//            for badge in allBadges {
//                if badge.isEligible(for: self, in: allPanini) {
//                    let badgeEntity = BadgeEntity(title: badge.title, mult: badge.mult)
//                    newBadges.insert(badgeEntity)
//                }
//            }
//            self.badges = newBadges
//        }
}
