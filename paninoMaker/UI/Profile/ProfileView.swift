//
//  ProfileView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @EnvironmentObject var user: UserModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingImagePicker = false
    @State private var showCameraPicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var showActionSheet = false
    @State private var propic: UIImage?
    @State private var badgeSelezionato: String?
    @State private var showPopoverLevel: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Button {
                    showActionSheet = true
                } label: {
                    if let image = propic {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(
                        title: Text("Scegli immagine profilo"),
                        buttons: [
                            .default(Text("Scatta foto")) { showCameraPicker = true },
                            .default(Text("Seleziona dalla libreria")) { showingImagePicker = true },
                            .cancel()
                        ]
                    )
                }
                .sheet(isPresented: $showingImagePicker) {
                    
                }
                .sheet(isPresented: $showCameraPicker) {
                    CameraPicker(image: $propic)
                }
            }
            
            if (!user.isLogged) {
                NavigationLink(destination: LoginView()) {
                    VStack {
                        Text("Accedi")
                            .font(.title)
                            .foregroundStyle(Color.blue)
                        Text("Per accedere alle gamifications\n tieni traccia dei tuoi badge e del tuo livello!")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            } else {
                Text(user.username)
                    .font(.title)
            }
            
            Divider()
            
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
                    
                    Button {
                        showPopoverLevel.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                            .imageScale(.small)
                    }
                    .foregroundStyle(.gray)
                    .offset(x: 35,y: -25)
                    .popover(
                        isPresented: $showPopoverLevel,
                        arrowEdge: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            let nextLevel = user.level + 1
                            Text("Slocca al livello \(nextLevel)")
                                .font(.headline)
                                .fontWeight(.bold)
                            ForEach(IngredientStore().ingredients(wantedLevel: nextLevel)) { ingredient in
                                HStack {
                                    Text("\(ingredient.name) - ")
                                    Text(ingredient.category.displayName)
                                        .font(.caption)
                                        .foregroundStyle(ingredient.category.color)
                                }
                                
                            }
                        }
                        .padding()
                        .presentationCompactAdaptation(.popover)
                    }
                }
                .padding()
            }
            
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
            Divider().padding()
            
            Spacer(minLength: 40)
            
            Text("Your Panino Badges")
                .font(.title)
                .fontWeight(.bold)
            PaninoChart(allPanini: allPanini)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    themeManager.toggleTheme()
                } label: {
                    Image(systemName: themeManager.iconName)
                }
                .animation(.easeInOut, value: themeManager.selectedColorScheme)
            }
        }
    }
}

#Preview {
    ProfileView()
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
        .environmentObject(ThemeManager())
}
