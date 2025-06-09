//
//  CardWrapper.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct CardWrapper<Content: View>: View {
    let content: Content
    var color: Color
    
    init(_ color: Color, @ViewBuilder content: () -> Content) {
        self.color = color
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.2))
            .cornerRadius(16)
            .padding(.bottom, 5)
    }
}

#Preview {
    CardWrapper(.gray) {
        Text("Hello World!")
    }
}
