//
//  ProfileGamifications.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 10/06/25.
//

import SwiftUI
import SwiftData

struct ProfileGamifications: View {
    @EnvironmentObject var user: UserModel
    @State private var showPopoverLevel: Bool = false
    @Query(filter: #Predicate { !$0.inTrash }, sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    
    
    var body: some View {
        VStack {
            ZStack {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(user.pex % UserGamifications.pointsPerLevelUp) / CGFloat(UserGamifications.pointsPerLevelUp))
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 150, height: 150)
                }
                
                VStack {
                    Text("LVL. \(user.level)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(user.pex) PEX")
                        .fontWeight(.bold)
                }
                
                // Level info button
                Button {
                    showPopoverLevel.toggle()
                } label: {
                    if user.level == UserGamifications.levelCap {
                        Image(systemName: "crown.fill")
                            .imageScale(.small)
                            .foregroundStyle(.yellow)
                    } else {
                        Image(systemName: "info.circle")
                            .imageScale(.small)
                    }
                }
                .foregroundStyle(.gray)
                .offset(x: 45,y: -25)
                .popover(
                    isPresented: $showPopoverLevel,
                    arrowEdge: .top) {
                        VStack(spacing: 8) {
                            if user.level == UserGamifications.levelCap {
                                VStack(spacing: 8) {
                                    Text("Congratulazioni!!!!!")
                                        .fontWeight(.bold)
                                        .font(.headline)
                                    
                                    Text("Hai raggiunto il livello massimo,\ned hai sbloccato tutti gli ingredienti.")
                                        .font(.body)
                                }
                            } else {
                                let nextLevel = user.level + 1
                                Text("Slocca al livello \(nextLevel)")
                                    .fontWeight(.bold)
                                    .font(.headline)
                                ForEach(IngredientStore().ingredients(wantedLevel: nextLevel)) { ingredient in
                                    HStack {
                                        Text("\(ingredient.name)")
                                        Text("(\(ingredient.category.displayName))")
                                            .foregroundStyle(ingredient.category.color)
                                    }
                                    .font(.body)
                                }
                            }
                        }
                        .padding()
                        .presentationCompactAdaptation(.popover)
                    }
            }
            .padding()
            
            // Badges count
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                ForEach(BadgesLibrary.all, id: \.title) { badge in
                    VStack {
                        let count = allPanini.filter {
                            $0.badges.contains { $0.title == badge.title }
                        }.count
                        
                        BadgeView(badge: badge)
                            .opacity(count > 0 ? 1.0 : 0.3)
                        
                        Text("\(count)x")
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileGamifications()
        .environmentObject(UserModel())
        .environmentObject(ThemeManager())
        .modelContainer(PreviewData.makeModelContainer())
}
