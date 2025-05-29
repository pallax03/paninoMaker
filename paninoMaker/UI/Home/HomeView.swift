//
//  HomeView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct HomeView: View {
    @State var selectedMenu: Menu?
    @State var selectedPanino: Panino?
    
    var body: some View {
        NavigationSplitView(/*preferredCompactColumn: .constant(.content)*/) {
            PaninoSidebar(selectedMenu: $selectedMenu)
        } content: {
            if let menu = selectedMenu {
                PaninoContent(selectedPanino: $selectedPanino, menu: menu)
            } else {
                Text("Select a menu")
            }
        } detail: {
            if let panino = selectedPanino {
                PaninoDetail(panino: panino)
                .padding()
            } else {
                Text("Select an item")
            }
        }
    }
}

class DataModel: ObservableObject {
    @Published var menus: [Menu] = [
        Menu(name: "All", panini: [
            Panino(name: "BigMac"),
            Panino(name: "Cheeseburger"),
        ])
    ]
}

#Preview {
    HomeView()
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
}
