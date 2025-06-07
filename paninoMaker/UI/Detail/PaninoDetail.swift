//
//  PaninoDetail.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import PhotosUI
import MapItemPicker
import MapKit

struct PaninoDetail: View {
    @State var panino: Panino
    @State private var isComposing: Bool = false
    @State private var isMapOpen: Bool = false
    @State private var isReviewing: Bool = false
    @State private var cameraPosition: MapCameraPosition = .automatic
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        TextField(
                            text: Binding(
                                get: { panino.name },
                                set: { panino.name = $0.isEmpty ? "" : $0 }
                            )) {
                                Text("New Panino")
                            }
                            .font(.title)
                            .focused($isFocused)
                            
                        
                        Spacer()
                        
                        Button {
                            panino.isSaved.toggle()
                        } label: {
                            Image(systemName: panino.isSaved ? "bookmark.fill" : "bookmark")
                                .foregroundStyle(.orange)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text(panino.creationDate.formatted(date: .numeric, time: .omitted))
                        
                        Spacer()
                        
                        Text(panino.owner ?? "No owner")
                    }
                    .font(.footnote)

                }
                
                ScrollView {
                    CardWrapper {
                        PaninoPhotos(panino: panino)
                    }
                    
                    Spacer()
                    
                    CardWrapper {
                        Button {
                            isComposing = true
                        } label: {
                            ComposerPreview(composer: panino.composer)
                        }
                        .sheet(isPresented: $isComposing, content: {
                            ComposerSheet(panino: $panino, draftComposer: panino.composer.copy())
                        })
                    }
                    
                    CardWrapper {
                        VStack {
                            HStack {
                                Text("Badges")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                                }
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                                ForEach(Array(panino.badges).sorted { $0.title < $1.title }, id: \.title) { entity in
                                    BadgeView(badge: entity.resolvedBadge!)
                                }
                            }
                        }
                    }
                    
                    CardWrapper {
                        VStack {
                            Text("Tocca per valutare")
                                .padding(.bottom, 5)
                            
                            HStack {
                                ForEach(1...5, id: \.self) { index in
                                    Button {
                                        panino.rating = index
                                        isReviewing = true
                                    } label: {
                                        Image(systemName: index <= panino.rating ?? 0 ? "star.fill" : "star")
                                            .font(.title)
                                    }
                                }
                            }
                            .padding(.bottom, 5)
                            
                            if panino.rating != nil {
                                Divider()
                                
                                TextField(
                                    text: Binding(
                                        get: { panino.ratingDescription ?? "" },
                                        set: { panino.ratingDescription = $0.isEmpty ? nil : $0 }
                                    )) {
                                        Text("Aggiungi una descrizione...")
                                    }
                                    .focused($isFocused)
                            }
                        }
                    }
                    
                    CardWrapper {
                        Button {
                            isMapOpen = true
                        } label: {
                            if panino.coordinates != nil {
                                let coordinate = panino.coordinates!

                                Map(position: $cameraPosition) {
                                    Marker(panino.name, coordinate: coordinate)
                                        .tint(.red)
                                }
                                .frame(height: 150)
                                .cornerRadius(10)
                            } else {
                                Text("Pin Mappa")
                            }
                        }
                        .mapItemPickerSheet(isPresented: $isMapOpen) { mapItem in
                            panino.setCoordinates(mapItem.location)
                        }
                    }
                }
            }
            .padding()
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(.all, edges: .bottom)
        }
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
