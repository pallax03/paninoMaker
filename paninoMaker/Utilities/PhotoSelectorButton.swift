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
    @State var selectedImages: UIImage?
    
    @Binding var selectedPhotoItems: [PhotosPickerItem]
    var maxSelectionCount: Int
    let label: Content
    
    init(selectedPhotoItems: Binding<[PhotosPickerItem]>, maxSelectionCount: Int = 1, @ViewBuilder label: () -> Content) {
        self._selectedPhotoItems = selectedPhotoItems
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
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: $selectedImages)
        }
    }
}

//#Preview {
//    PhotoSelectorButton { Text("Tap me") }
//}
