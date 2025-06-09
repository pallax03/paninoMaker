//
//  CardWrapper.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct CardWrapper<Content: View>: View {
    var title: String
    var color: Color
    let content: Content
    
    init(title: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.color = color
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
                
                Spacer()
            }
            
            content
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.2))
        .cornerRadius(16)
        .padding(.bottom, 5)
    }
}

#Preview {
    CardWrapper(title: "Test", color: .gray) {
        Text("Hello World!")
    }
    .environmentObject(UserModel())
    .modelContainer(PreviewData.makeModelContainer())
}
