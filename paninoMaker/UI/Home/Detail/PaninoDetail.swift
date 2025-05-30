//
//  PaninoDetail.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import PhotosUI

struct PaninoDetail: View {
    @State var panino: Panino
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var showComposer: Bool = false
    @State private var showMap: Bool = false
    @State private var isReviewing: Bool = false
    @State private var reviewDescription: String = ""
    @State private var isFavorite: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        Text(panino.name)
                            .font(.title)
                        
                        Spacer()
                        
                        Button {
                            isFavorite.toggle()
                        } label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundStyle(.red)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("27/05/2025")
                            .font(.footnote)
                        
                        Spacer()
                    }
                }
                
                ScrollView {
                    CardWrapper {
                        PaninoPhotos(
                            selectedItems: $selectedItems,
                            selectedImages: $selectedImages
                        )
                    }
                    
                    Spacer()
                    
                    CardWrapper {
                        Button {
                            showComposer = true
                        } label: {
                            Text("Composer")
                        }
                        .sheet(isPresented: $showComposer, content: {
                            ComposerSheet(composer: $panino.composer, draftComposer: panino.composer.copy())
                        })
                    }
                    
                    CardWrapper {
                        BadgeView()
                            .frame(width: 50)
                    }
                    
                    CardWrapper {
                        VStack {
                            Text("Tocca per valutare")
                                .padding(.bottom, 5)
                            
                            HStack {
                                ForEach(0..<5) { _ in
                                    Button {
                                        isReviewing = true
                                    } label: {
                                        Image(systemName: "star")
                                            .font(.title)
                                    }
                                }
                            }
                            .padding(.bottom, 5)
                            
                            if isReviewing {
                                Divider()
                                
                                TextField(text: $reviewDescription) {
                                    Text("Aggiungi una descrizione...")
                                }
                            }
                        }
                    }
                    
                    CardWrapper {
                        Button {
                            showMap = true
                        } label: {
                            Text("Pin Mappa")
                        }
                        .sheet(isPresented: $showMap, content: {
                            
                        })
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

#Preview {
    PaninoDetail(panino: PreviewData.samplePanini.first!)
        .environmentObject(UserModel())
}
