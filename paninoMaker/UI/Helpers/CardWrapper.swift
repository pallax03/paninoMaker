//
//  CardWrapper.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct CardWrapper<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.3), radius: 3, x: 5, y: 5)
            .padding(.bottom, 5)
    }
}

#Preview {
    CardWrapper {
        Text("Hello World!")
    }
}
