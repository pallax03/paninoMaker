//
//  PaninoDetailRating.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 10/06/25.
//

import SwiftUI
import SwiftData

struct PaninoDetailRating: View {
    @State private var isReviewing: Bool = false
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]


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
        .onChange(of: panino.rating) {
            GamificationManager.shared.recalculateAll(panini: allPanini)
        }
        .onChange(of: panino.ratingDescription) {
            GamificationManager.shared.recalculateAll(panini: allPanini)
        }
    }
}

#Preview {
    CardWrapper(title: "Recensione", color: .blue) {
        PaninoDetailRating(panino: Panino())
    }
    .environmentObject(UserModel())
    .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
