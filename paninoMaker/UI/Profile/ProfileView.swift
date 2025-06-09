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
    @Query(filter: #Predicate { !$0.inTrash }, sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @EnvironmentObject var user: UserModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingImagePicker = false
    @State private var showCameraPicker = false
    @State private var showActionSheet = false
    @State private var badgeSelezionato: String?
    @State private var showPopoverLevel: Bool = false
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var showCamera: Bool = false
    @State private var showLibrary: Bool = false
    @State private var selectedPhotos: [UIImage] = []
    
    var body: some View {
        ScrollView {
            PhotoSelectorButton(selectedPhotos: $selectedPhotos) {
                if let image = user.propic {
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
            .onChange(of: selectedPhotos) { oldValue, newValue in
                for item in newValue {
                    user.setPropic(item)
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
                VStack {
                    Text(user.username)
                        .font(.title)
                    
                    Button(action: {
                        user.logout()
                    }, label: {
                        Text("Logout")
                            .font(.title3)
                            .foregroundStyle(Color.blue)
                    })
                }
            }
            
            Divider().padding()
            
            if user.isLogged {
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
                
                Divider().padding()
                
                Spacer(minLength: 40)
                
                Text("Your Panino Badges")
                    .font(.title)
                    .fontWeight(.bold)
                PaninoChart(allPanini: allPanini)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    themeManager.toggleTheme()
                } label: {
                    HStack {
                        Image(systemName: themeManager.iconName)
                        Text(themeManager.name)
                    }
                }
                .animation(.easeInOut, value: themeManager.selectedColorScheme)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
            .environmentObject(UserModel())
            .environmentObject(ThemeManager())
    }
}
