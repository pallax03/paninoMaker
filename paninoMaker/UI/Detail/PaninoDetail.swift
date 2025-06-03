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
    @State private var isComposing: Bool = false
    @State private var isMapOpen: Bool = false
    @State private var isReviewing: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Text(panino.name)
                            .font(.title)
                        
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
                            ComposerPreview(panino: panino)

                            //Text("Composer")
                        }
                        .sheet(isPresented: $isComposing, content: {
                            ComposerSheet(composer: $panino.composer, draftComposer: panino.composer.copy())
                        })
                    }
                    
                    CardWrapper {
                        VStack {
                            HStack(alignment: .firstTextBaseline) {
                                Text("Badges")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                                }
                            ForEach(Array(panino.badges).sorted { $0.title < $1.title }, id: \.title) { entity in
                                BadgeView(badge: entity.resolvedBadge!)
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
                            }
                        }
                    }
                    
                    CardWrapper {
                        Button {
                            isMapOpen = true
                        } label: {
                            Text("Pin Mappa")
                        }
                        .sheet(isPresented: $isMapOpen, content: {
                            
                        })
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
