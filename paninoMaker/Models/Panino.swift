//
//  Panino.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation

struct Panino: Identifiable {
    var id = UUID()
    var title: String
    var owner: String
    var ingredients: [Ingredient]
    var isFavorite: Bool
    var creationDate: Date
    var modifiedDate: Date
    var rating: Int
    var ratingDescription: Int
    
}
