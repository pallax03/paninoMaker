//
//  ContentView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var user: UserModel
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Query(sort: \Menu.position, order: .forward) var allMenus: [Menu]
    @State var selectedMenu: SidebarSection? = .all
    @State var selectedPanino: Panino?

    @State private var isShowingNewMenuAlert = false
    @State private var newMenuTitle = ""
    @State private var selectedPanini: Set<Panino> = []
    @State private var paninoToMove: Panino? = nil
    
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
                        isShowingNewMenuAlert: $isShowingNewMenuAlert,
                        newMenuTitle: $newMenuTitle,
                        paninoToMove: $paninoToMove
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
        .task {
            GamificationManager.shared.recalculateAll(panini: allPanini, user: user)
        }
        .overlay(alignment: .bottom) {
            BottomBar(
                selectedMenu: $selectedMenu,
                selectedPanino: $selectedPanino,
                isShowingNewMenuAlert: $isShowingNewMenuAlert,
                newMenuTitle: $newMenuTitle
            )
        }
        .alert("New Menu", isPresented: $isShowingNewMenuAlert) {
            TextField("Title of the new menu", text: $newMenuTitle)
            Button("Create", action: {
                let menu = Menu(title: newMenuTitle.isEmpty ? "No title" : newMenuTitle, panini: [])
                modelContext.insert(menu)
                if let panino = paninoToMove {
                    panino.restoreFromTrash(menu: menu)
                    paninoToMove = nil
                }
                selectedMenu = .menus(menu)
                newMenuTitle = ""
                try? modelContext.save() 
            })
            Button("Cancel", role: .cancel) {
                newMenuTitle = ""
                paninoToMove = nil
            }
        } message: {
            Text("Insert a new menu title.")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
        .environmentObject(ThemeManager())
}
