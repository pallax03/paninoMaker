//
//  PaninoDetail.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import EventKit
import SwiftData

struct PaninoDetail: View {
    @State var panino: Panino
    @State private var showConfirmationDialog: Bool = false
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    
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
                        
                        Spacer()
                        
                        Button {
                            panino.isSaved.toggle()
                            GamificationManager.shared.recalculateAll(panini: allPanini)
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
                        PaninoDetailExperience(panino: panino, callback: {
                            GamificationManager.shared.recalculateAll(panini: allPanini)
                        })
                    }
                    
                    // Composer
                    CardWrapper(title: "Composer", color: .yellow) {
                        PaninoDetailComposer(panino: panino)
                    }
                    
                    // Rating
                    CardWrapper(title: "Recensione", color: .blue) {
                        PaninoDetailRating(panino: panino, callback: {
                            GamificationManager.shared.recalculateAll(panini: allPanini)
                        })
                    }
                    
                    // Map
                    CardWrapper(title: "Mappa",color: .green) {
                        PaninoDetailMap(panino: panino, callback: {
                            GamificationManager.shared.recalculateAll(panini: allPanini)
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
        .onChange(of: showConfirmationDialog) { _, isPresented in
            if !isPresented {
                GamificationManager.shared.recalculateAll(panini: allPanini)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PaninoDetail(panino: PreviewData.samplePanini.first!)
            .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
            .environmentObject(UserModel())
    }
}
