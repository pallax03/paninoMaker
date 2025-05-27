//
//  Ingredient.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation

struct Ingredient: Codable {
    var id = UUID()
    var name: String
    var image: String
}
