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
import PhotosUI
import EventKit

struct PaninoDetail: View {
    @State var panino: Panino
    @State private var isComposing: Bool = false
    @State private var isMapOpen: Bool = false
    @State private var isReviewing: Bool = false
    @State private var cameraPosition: MapCameraPosition = .automatic
    @FocusState private var isFocused: Bool
    @State private var showConfirmationDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    // Title
                    HStack {
                        TextField(text: $panino.name) {
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
                    
                    Divider().padding(.top)
                    
                    // Info
                    HStack {
                        PaninoCalendar(date: panino.creationDate, title: panino.name)
                        
                        Spacer()
                        
                        Text(panino.owner ?? "No owner")
                    }
                    .font(.body)
                }
                .padding(.bottom)
                
                ScrollView {
                    // Experience
                    CardWrapper(title: "Experience", color:.indigo) {
                        PaninoPhotos(panino: panino)
                    }
                    
                    // Composer
                    CardWrapper(title: "Composer",color: .yellow) {
                        VStack {
                            Button {
                                isComposing = true
                            } label: {
                                ComposerPreview(composer: panino.composer)
                            }
                            .sheet(isPresented: $isComposing, content: {
                                ComposerSheet(panino: $panino, draftComposer: panino.composer.copy())
                            })
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                                ForEach(Array(panino.badges).sorted { $0.title < $1.title }, id: \.title) { entity in
                                    BadgeView(badge: entity.resolvedBadge!)
                                }
                            }
                        }
                    }
                    
                    // Rating
                    CardWrapper(title: "Recensione", color: .blue) {
                        VStack(spacing: 10) {
                            Text("Tocca per valutare")
                            
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
                        .padding()
                    }
                    
                    // Map
                    CardWrapper(title: "Mappa",color: .green) {
                        Button {
                            isMapOpen = true
                        } label: {
                            if panino.coordinates != nil {
                                Map(position: $cameraPosition) {
                                    Annotation(panino.name, coordinate: panino.coordinates!) {
                                        Text("🍔")
                                            .font(.title)
                                    }
                                }
                                .frame(height: 150)
                                .cornerRadius(10)
                            } else {
                                Label("Imposta la posizione", systemImage: "mappin")
                                    .padding()
                                    .background(Color.green.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding()
                        .foregroundStyle(.green)
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
                    showConfirmationDialog.toggle()
                } label: {
                    ZStack {
                        Text("🍔")
                            .font(.title)
                        
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .offset(x: 13, y: -13)
                            .tint(.red)
                    }
                }
            }
        }
        .confirmationDialog("Reset Panino", isPresented: $showConfirmationDialog) {
            
            Button("Rimuovi Experience") { panino.resetImages() }
            
            Button("Rimuovi Composer") { panino.resetComposer() }
            
            Button("Rimuovi Recensione") { panino.resetRating() }
            
            Button("Rimuovi Mappa") { panino.resetMap() }
            
            Button("Reset Panino", role: .destructive) { panino.resetPanino() }
            
            Button("Annulla", role: .cancel) {}
        }
    }
}

#Preview {
    NavigationStack {
        PaninoDetail(panino: PreviewData.samplePanini.first!)
            .environmentObject(UserModel())
    }
}
