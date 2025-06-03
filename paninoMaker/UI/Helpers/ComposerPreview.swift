//
//  ComposerPreview.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 03/06/25.
//

import SwiftUI

struct ComposerPreview: View {
    let composer: Composer
    
    var body: some View {
        VStack(spacing: 2) {
            Image(composer.top.imageName)
            .resizable()
            .cornerRadius(10)
            
            ForEach(composer.ingredients) { ingredient in
                if let img = UIImage(named: ingredient.imageName) {
                    Image(uiImage: img)
                    .resizable()
                    .cornerRadius(10)
                } else {
                    Rectangle()
                    .fill(.green)
                    .cornerRadius(10)
                }
            }
            
            
            Image(composer.bottom.imageName)
            .resizable()
            .cornerRadius(10)
        }
        .frame(width: 150, height: 150)
    }
}

#Preview {
    ComposerPreview(composer: PreviewData.samplePanini[0].composer)
}
