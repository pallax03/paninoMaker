//
//  BadgeView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 30/05/25.
//

import SwiftUI

struct BadgeView: View {
    var badge: any Badge
    @State var showPopover: Bool = false

    var body: some View {
        Button {
            showPopover.toggle()
        } label: {
            badge.view
                .font(.title)
                .foregroundColor(badge.color)
                .padding(15)
                .background(badge.color.opacity(0.2))
                .clipShape(Circle())
        }
        .popover(
            isPresented: $showPopover,
            arrowEdge: .bottom) {
            VStack(alignment: .leading, spacing: 8) {
                Text(badge.title)
                    .font(.headline)
                
                Text(badge.description)
                    .font(.body)
            }
            .padding()
            .presentationCompactAdaptation(.popover)
        }
    }
}

#Preview {
    let badge: any Badge = BadgesLibrary.randomBadges(count: 1).first!.resolvedBadge!
    BadgeView(badge: BunBadge())
}
