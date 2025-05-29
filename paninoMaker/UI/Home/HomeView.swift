//
//  HomeView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Query(sort: \Menu.title, order: .reverse) var allMenus: [Menu]
    @State var selectedMenu: SidebarSection?
    @State var selectedPanino: Panino?
    
    var body: some View {
        NavigationSplitView(/*preferredCompactColumn: .constant(.content)*/) {
            PaninoSidebar(selectedMenu: $selectedMenu)
        } content: {
            if let section = selectedMenu {
                switch section {
                    case .all:
                    PaninoContent(title: "All Panini", panini: allPanini, selectedPanino: $selectedPanino, selectedMenu: nil)
                    case .map:
                    MapView()
                    case .imported:
                    PaninoContent(title: "Imported Panini", panini: allPanini, selectedPanino: $selectedPanino, selectedMenu: nil)
                    case .menus(let menu):
                        PaninoContent(title: menu.title, panini: menu.panini, selectedPanino: $selectedPanino, selectedMenu: menu)
                    }
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

#Preview {
    HomeView()
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
}
