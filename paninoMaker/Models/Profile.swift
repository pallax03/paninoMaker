//
//  Profile.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import SwiftUI

struct Profile {
    var username: String
    var pex: Int
    var level: Int { pex / 100 }
}
