//
//  BadgeView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct BadgeView: View {
    var body: some View {
        HStack {
            ForEach(0..<6) { _ in
                Badge()
            }
        }
    }
}

struct Badge: View {
    var body: some View {
        VStack {
            Circle()
                .fill(Color.white)
                .overlay {
                    Circle().stroke(Color.green, lineWidth: 2)
                }
            Text("x 0")
        }
    }
}

#Preview {
    BadgeView()
}
