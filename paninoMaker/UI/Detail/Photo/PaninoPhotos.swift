//
//  PaninoPhotos.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 30/05/25.
//

import SwiftUI
import PhotosUI

struct PaninoPhotos: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    let panino: Panino

    var body: some View {
        VStack {
            if panino.images.isEmpty {
                PaninoPicker(panino: panino, selectedItems: $selectedItems) {
                    Label("Seleziona immagini", systemImage: "photo.on.rectangle.angled")
                        .padding()
                        .background(Color.indigo.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                // Mostra le immagini selezionate
                ScrollView(.horizontal) {
                    HStack {
                        PaninoPicker(panino: panino, selectedItems: $selectedItems) {
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
        .padding()
    }
}

struct PaninoPicker<Content: View>: View {
    let panino: Panino
    @Binding var selectedItems: [PhotosPickerItem]
    let content: () -> Content
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItems,
            maxSelectionCount: 10,  // Numero massimo di immagini selezionabili
            matching: .images,
            photoLibrary: .shared()
        ) {
            content()
        }
        .onChange(of: selectedItems) { oldValue, newValue in
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
    }
}

//#Preview {
//    PaninoPhotos(selectedItems: .constant(nil), panino: PreviewData.samplePanino)
//}
