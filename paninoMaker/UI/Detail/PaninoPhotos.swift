//
//  PaninoPhotos.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 30/05/25.
//

import SwiftUI
import PhotosUI

struct PaninoPhotos: View {
    @State private var selectedPhotos: [UIImage] = []
    private let maxSelectionCount: Int = 10
    let panino: Panino
    
    var body: some View {
        VStack {
            if panino.images.isEmpty {
                PhotoSelectorButton(selectedPhotos: $selectedPhotos, maxSelectionCount: maxSelectionCount) {
                    Label("Seleziona immagini", systemImage: "photo.on.rectangle.angled")
                        .padding()
                        .background(Color.indigo.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                // Mostra le immagini selezionate
                ScrollView(.horizontal) {
                    HStack {
                        PhotoSelectorButton(selectedPhotos: $selectedPhotos, maxSelectionCount: maxSelectionCount) {
                            ForEach(panino.images, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 3)
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .onChange(of: selectedPhotos) { oldValue, newValue in
            panino.resetImages()
            for item in newValue {
                panino.addImage(item)
            }
        }
        .padding()
    }
}


//#Preview {
//    PaninoPhotos(selectedItems: .constant(nil), panino: PreviewData.samplePanino)
//}
