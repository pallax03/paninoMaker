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
    @State private var selectedPhotos: [UIImage] = []
    
    var body: some View {
        ScrollView {
            // Profile picture
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
            
            // User login button
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
            } else { // User email
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
            
            Divider().padding(.vertical, 20)
            
            // Only if user is logged
            if user.isLogged {
                ProfileGamifications()
                
                Divider().padding(.vertical, 20)
                
                PaninoChart()
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    themeManager.toggleTheme()
                } label: {
                    HStack {
                        if !themeManager.iconName.isEmpty {
                            Image(systemName: themeManager.iconName)
                        }
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
            .environmentObject(UserModel())
            .environmentObject(ThemeManager())
            .modelContainer(PreviewData.makeModelContainer())
    }
}
