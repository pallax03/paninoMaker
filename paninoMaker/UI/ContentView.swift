//
//  ContentView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        TabView {
//            MapView()
//                .tabItem {
//                    Label("Map", systemImage: "map")
//                }
//            
//            HomeView()
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
//            
//            ProfileView()
//                .tabItem {
//                    Label("Profile", systemImage: "person.circle")
//                }
//        }
        HomeView()
    }
}

#Preview {
    ContentView()
        .environmentObject(UserModel())
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
