//
//  ContentView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Query(sort: \Menu.position, order: .forward) var allMenus: [Menu]
    @State var selectedMenu: SidebarSection?
    @State var selectedPanino: Panino?

    @State private var isShowingNewMenuAlert = false
    @State private var newMenuTitle = ""
    
    var panini: [Panino] {
        guard let selectedMenu = selectedMenu else { return [] }
        return selectedMenu.filteredPanini(allPanini: allPanini)
    }
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                MenuSidebar(selectedMenu: $selectedMenu)
            }
        } content: {
                if let section = selectedMenu {
                    section.makeContentView(
                        panini: panini,
                        selectedPanino: $selectedPanino,
                        selectedMenu: $selectedMenu,
                        allPanini: allPanini
                    )
                } else {
                    Text("Select a menu")
                }
        } detail: {
            ZStack {
                if let panino = selectedPanino {
                    PaninoDetail(panino: panino)
                        .frame(maxHeight: .infinity, alignment: .top)
                } else {
                    Text("Select an item")
                        .frame(maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .overlay(alignment: .bottom) {
            BottomBar(selectedMenu: $selectedMenu, selectedPanino: $selectedPanino)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
}
