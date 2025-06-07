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
            .cornerRadius(16)
            .padding(.bottom, 5)
    }
}

#Preview {
    CardWrapper {
        Text("Hello World!")
    }
}
