//
//  Menu.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Menu {
    var title: String
    var panini: [Panino] = []
    
    init(title: String, panini: [Panino] = []) {
        self.title = title
        self.panini = panini
    }
}
