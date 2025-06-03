//
//  ComposerPreview.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 03/06/25.
//

import SwiftUI

struct ComposerPreview: View {
    let panino: Panino
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(.brown)
                    .cornerRadius(10)
            }
            
            ForEach(panino.composer.ingredients) { ingredient in
                ZStack {
                    Rectangle()
                    .fill(.green)
                    .cornerRadius(10)
                }
            }
            
            ZStack {
                Rectangle()
                    .fill(.brown)
                    .cornerRadius(10)
            }
        }
        .frame(width: 150, height: 150)
    }
}

#Preview {
    ComposerPreview(panino: PreviewData.samplePanino)
}
