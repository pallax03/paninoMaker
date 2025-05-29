//
//  Menu.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import SwiftUI

struct Menu: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let panini: [Panino]
}
