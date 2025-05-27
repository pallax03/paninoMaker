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
    @State private var showComposer: Bool = false
    @State private var showMap: Bool = false
    @State private var isReviewing: Bool = false
    @State private var reviewDescription: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
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
                }
                
                ScrollView {
                    CardWrapper {
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Text("Seleziona foto")
                        }
                    }
                    
                    
                    Spacer()
                    
                    CardWrapper {
                        Button {
                            showComposer = true
                        } label: {
                            Text("Composer")
                        }
                        .sheet(isPresented: $showComposer, content: {
                            ComposerSheet()
                        })
                    }
                    
                    CardWrapper {
                        Badge()
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
    PaninoView()
}
