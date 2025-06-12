//
//  PaninoDetailExperience.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 30/05/25.
//

import SwiftUI
import PhotosUI

struct PaninoDetailExperience: View {
    let panino: Panino
    var callback: () -> Void
    @State private var selectedPhotos: [UIImage] = []
    private let maxSelectionCount: Int = 10
    
    var body: some View {
        VStack {
            if panino.images.isEmpty {
                PhotoSelectorButton(selectedPhotos: $selectedPhotos, maxSelectionCount: maxSelectionCount) {
                    Label("Seleziona immagini", systemImage: "photo.on.rectangle.angled")
                        .padding()
                        .background(Color.indigo.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .foregroundStyle(.indigo)
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
                                    .shadow(radius: 3)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .onChange(of: selectedPhotos) { _, newValue in
            for item in newValue {
                panino.addImage(item)
            }
            selectedPhotos = []
            callback()
        }
    }
}


#Preview {
    CardWrapper(title: "Experience",color: .indigo) {
        PaninoDetailExperience(panino: Panino(), callback: {})
    }
    .environmentObject(UserModel())
}
