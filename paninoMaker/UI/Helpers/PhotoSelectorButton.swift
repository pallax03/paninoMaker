//
//  PhotoSelectorButton.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 08/06/25.
//

import SwiftUI
import PhotosUI

struct PhotoSelectorButton<Content: View>: View {
    @State var showConfirmationDialog: Bool = false
    @State var showLibrary: Bool = false
    @State var showCamera: Bool = false
    @Binding var selectedPhotos: [UIImage]
    @State var selectedPhotoItems: [PhotosPickerItem] = []
    
    var maxSelectionCount: Int
    let label: Content
    
    init(selectedPhotos: Binding<[UIImage]>, maxSelectionCount: Int = 1, @ViewBuilder label: () -> Content) {
        self._selectedPhotos = selectedPhotos
        self.maxSelectionCount = maxSelectionCount
        self.label = label()
    }
    
    var body: some View {
        Button {
            showConfirmationDialog.toggle()
        } label: {
            label
        }
        .confirmationDialog("Seleziona foto", isPresented: $showConfirmationDialog) {
            
            Button("Libreria Foto") {
                showLibrary.toggle()
            }
            
            Button("Fotocamera") {
                showCamera.toggle()
            }
            
            Button("Annulla", role: .cancel) {}
        }
        .photosPicker(
            isPresented: $showLibrary,
            selection: $selectedPhotoItems,
            maxSelectionCount: maxSelectionCount,
            matching: .images
        )
        .onChange(of: selectedPhotoItems) { oldValue, newValue in
            Task {
                for item in newValue {
                    print(item)
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedPhotos.append(uiImage)
                        }
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(images: $selectedPhotos)
        }
    }
}

//#Preview {
//    PhotoSelectorButton { Text("Tap me") }
//}
