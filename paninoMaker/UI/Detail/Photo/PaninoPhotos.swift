//
//  PaninoPhotos.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 30/05/25.
//

import SwiftUI
import PhotosUI

struct PaninoPhotos: View {
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    private let maxSelectionCount: Int = 10
    let panino: Panino
    
    var body: some View {
        VStack {
            if panino.images.isEmpty {
                PhotoSelectorButton(selectedPhotoItems: $selectedPhotoItems, maxSelectionCount: maxSelectionCount) {
                    Label("Seleziona immagini", systemImage: "photo.on.rectangle.angled")
                        .padding()
                        .background(Color.indigo.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                // Mostra le immagini selezionate
                ScrollView(.horizontal) {
                    HStack {
                        PhotoSelectorButton(selectedPhotoItems: $selectedPhotoItems, maxSelectionCount: maxSelectionCount) {
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
        .onChange(of: selectedPhotoItems) { oldValue, newValue in
            Task {
                panino.resetImages()
                for item in newValue {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        panino.addImage(uiImage)
                    }
                }
            }
        }
        .padding()
    }
}


//#Preview {
//    PaninoPhotos(selectedItems: .constant(nil), panino: PreviewData.samplePanino)
//}
