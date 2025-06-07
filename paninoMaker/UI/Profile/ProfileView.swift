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
            
            Text(user.username)
                .font(.title)
            
            if (!user.isLogged) {
                NavigationLink(destination: LoginView()) {
                    Text("Accedi")
                        .foregroundStyle(Color.blue)
                }
            }
            
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 200)
                    .overlay {
                        Circle().stroke(.red, lineWidth: 4)
                    }
                
                VStack {
                    Text("LVL. \(user.level)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(user.pex) PEX")
                        .fontWeight(.bold)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "info.circle")
                }
                .foregroundStyle(.gray)
                .offset(x: 55,y: -25)
            }
            .foregroundStyle(.red)
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
