//
//  BadgeView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 30/05/25.
//

import SwiftUI

struct BadgeView: View {
    var badge: any Badge
    var body: some View {
        badge.view
    }
}

#Preview {
    let badge: any Badge = BadgesLibrary.randomBadges(count: 1).first!.resolvedBadge!
    BadgeView(badge: badge)
}
