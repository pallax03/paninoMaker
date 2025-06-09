//
//  PaninoDetailRating.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 10/06/25.
//

import SwiftUI

struct PaninoDetailRating: View {
    @State private var isReviewing: Bool = false

    let panino: Panino
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Tocca per valutare")
            
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Button {
                        panino.rating = index
                        isReviewing = true
                    } label: {
                        Image(systemName: index <= panino.rating ?? 0 ? "star.fill" : "star")
                            .font(.title)
                    }
                }
            }
            
            if panino.rating != nil {
                Divider()
                
                TextField(
                    text: Binding(
                        get: { panino.ratingDescription ?? "" },
                        set: { panino.ratingDescription = $0.isEmpty ? nil : $0 }
                    )) {
                        Text("Aggiungi una descrizione...")
                    }
            }
        }
        .padding()
    }
}

#Preview {
    CardWrapper(title: "Recensione", color: .blue) {
        PaninoDetailRating(panino: Panino())
    }
    .environmentObject(UserModel())
    .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
