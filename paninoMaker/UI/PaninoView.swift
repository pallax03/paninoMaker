//
//  PaninoView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import PhotosUI

struct PaninoView: View {
    
    @State private var selectedPhoto: PhotosPickerItem? = nil

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Titolo Panino")
                        .font(.title)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "heart")
                            .foregroundStyle(.red)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("27/05/2025")
                        .font(.footnote)
                    
                    Spacer()
                }
                .padding(.bottom)
                
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Seleziona foto")
                }
                
                Spacer()
                
                Text("Composer")
                
                Spacer()
                
                Text("Badges")
                
                Spacer()
                
                Text("Rating")
                
                Spacer()
                
                Text("Pin Mappa")
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

#Preview {
    PaninoView()
}
