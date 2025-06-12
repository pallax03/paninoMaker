//
//  ContentView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData
import UserNotifications
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var user: UserModel
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Query(sort: \MenuModel.position, order: .forward) var allMenus: [MenuModel]
    @State var selectedMenu: SidebarSection? = .all
    @State var selectedPanino: Panino?
    @State private var lastViewedPanino: Panino?
    @State private var isShowingMoveSheet: Bool = false
    @State private var isShowingNewMenuAlert: Bool = false
    @State private var newMenuTitle = ""
    @State private var selectedPanini: Set<Panino> = []
    @State private var paniniToMove: [Panino]? = nil
    @State private var searchPanino: String = ""
    
    var panini: [Panino] {
        guard let selectedMenu = selectedMenu else { return [] }
        return selectedMenu.filteredPanini(allPanini: allPanini, searchPanino: searchPanino)
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
                    isShowingMoveSheet: $isShowingMoveSheet,
                    isShowingNewMenuAlert: $isShowingNewMenuAlert,
                    newMenuTitle: $newMenuTitle,
                    paniniToMove: $paniniToMove,
                    searchPanino: $searchPanino
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
            await user.syncUserData()
            GamificationManager.shared.prepareForUser(user, panini: allPanini)
        }
        .overlay(alignment: .bottom) {
            BottomBar(
                selectedMenu: $selectedMenu,
                selectedPanino: $selectedPanino,
                isShowingMoveSheet: $isShowingMoveSheet,
                isShowingNewMenuAlert: $isShowingNewMenuAlert,
                newMenuTitle: $newMenuTitle,
                paniniToMove: $paniniToMove
            )
        }
        .sheet(isPresented: $isShowingMoveSheet) {
            MovePaniniSheet(
                onSelect: {menu in
                    if let unpacked = paniniToMove {
                        for panino in unpacked {
                            panino.restoreFromTrash(menu: menu)
                        }
                        paniniToMove = nil
                    }
                    selectedMenu = .menus(menu!)
                    try? modelContext.save()
                    GamificationManager.shared.recalculateAll(panini: allPanini)

                },
                onNewMenu: {
                    isShowingMoveSheet = false
                    isShowingNewMenuAlert = true
                },
                isPresented: $isShowingMoveSheet
            )
        }
        .alert("New Menu", isPresented: $isShowingNewMenuAlert) {
            TextField("Title of the new menu", text: $newMenuTitle)
            Button("Create", action: {
                let menu = MenuModel(title: newMenuTitle.isEmpty ? "No title" : newMenuTitle, panini: [])
                modelContext.insert(menu)
                if let unpacked = paniniToMove {
                    for panino in unpacked {
                        panino.restoreFromTrash(menu: menu)
                    }
                    paniniToMove = nil
                }
                selectedMenu = .menus(menu)
                newMenuTitle = ""
                try? modelContext.save()
                GamificationManager.shared.recalculateAll(panini: panini)
            })
            Button("Cancel", role: .cancel) {
                newMenuTitle = ""
                paniniToMove = nil
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
