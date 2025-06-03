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
    var position: Int = 0
    
    init(title: String, panini: [Panino] = []) {
        self.title = title
        self.panini = panini
    }
    
    func deletePanini() {
        for panino in panini {
            panino.isDeleted = true
        }
    }
}
