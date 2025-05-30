//
//  PaninoPhotos.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 30/05/25.
//

import SwiftUI
import PhotosUI

struct PaninoPhotos: View {
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]

    var body: some View {
        VStack {
            // Mostra le immagini selezionate
            ScrollView(.horizontal) {
                HStack {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 3)
                    }
                }
            }
            
            // Picker per selezionare immagini
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 10,  // Numero massimo di immagini selezionabili
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Seleziona immagini", systemImage: "photo.on.rectangle.angled")
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .onChange(of: selectedItems) { oldValue, newValue in
                Task {
                    selectedImages = []
                    for item in newValue {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImages.append(uiImage)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

//#Preview {
//    PaninoPhotos(selectedItems: .constant(nil), selectedImages: .constant(nil))
//}
