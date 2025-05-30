//
//  HomeView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Query(sort: \Menu.position, order: .forward) var allMenus: [Menu]
    @State var selectedMenu: SidebarSection?
    @State var selectedPanino: Panino?

    @State private var isShowingProfileSheet = false
    @State private var isShowingNewMenuAlert = false
    @State private var newMenuTitle = ""
    
    var panini: [Panino] {
        guard let selectedMenu = selectedMenu else { return [] }
        return selectedMenu.filteredPanini(allPanini: allPanini)
    }
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                PaninoSidebar(selectedMenu: $selectedMenu)
            }
        } content: {
            contentForSelectedSection()
        } detail: {
            VStack {
                if let panino = selectedPanino {
                    PaninoDetail(panino: panino)
                        .padding()
                } else {
                    Text("Select an item")
                }
            }
        }
        .overlay(alignment: .bottom) {
            bottomBar()
        }
    }
    
    @ViewBuilder
    private func contentForSelectedSection() -> some View {
        VStack(spacing: 0) {
            switch selectedMenu {
            case .all:
                PaninoContent(title: "All Panini", panini: panini, selectedPanino: $selectedPanino, selectedMenu: nil, isTrash: false)
            case .map:
                MapView()
            case .imported:
                PaninoContent(title: "Imported Panini", panini: panini, selectedPanino: $selectedPanino, selectedMenu: nil, isTrash: false)
            case .trash:
                PaninoContent(title: "Recycle Bin", panini: panini, selectedPanino: $selectedPanino, selectedMenu: nil, isTrash: true)
            case .menus(let menu):
                PaninoContent(title: menu.title, panini: panini, selectedPanino: $selectedPanino, selectedMenu: menu, isTrash: false)
            case .none:
                Text("Select a menu")
            }
        }
    }
    
    @ViewBuilder
    func bottomBar() -> some View {
        if isBottomBarVisible {
            VStack(spacing: 0) {
                Divider()
                HStack(alignment: .center) {
                    
                    if showNewMenuButton {
                        Button {
                            isShowingNewMenuAlert = true
                        } label: {
                            Image(systemName: "folder.badge.plus")
                                .imageScale(.large)
                        }
                    }
                    
                    if showPaniniCount {
                        Spacer()
                        Text("\(visiblePaniniCount) Panini")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if showPlusButton {
                        Button {
                            selectedMenu = selectedMenu ?? .all
                            let panino = Panino(name: "", menu: selectedMenu?.menu)
                            modelContext.insert(panino)
                        } label: {
                            Image(systemName: "plus")
                                .imageScale(.large)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .alert("New Menu", isPresented: $isShowingNewMenuAlert) {
                    TextField("Title of the new menu", text: $newMenuTitle)
                    Button("Create", action: {
                        let menu = Menu(title: newMenuTitle.isEmpty ? "No title" : newMenuTitle, panini: [])
                        modelContext.insert(menu)
                        selectedMenu = .menus(menu)
                        newMenuTitle = ""
                    })
                    Button("Cancel", role: .cancel) {
                        newMenuTitle = ""
                    }
                } message: {
                    Text("Insert a new menu title.")
                }
            }
        }
    }

    var isBottomBarVisible: Bool {
        guard let section = selectedMenu else { return true }
        switch section {
        case .trash, .map:
            return false
        default:
            return true
        }
    }

    var showNewMenuButton: Bool {
        selectedMenu == nil
    }

    var showPlusButton: Bool {
        guard let section = selectedMenu else { return true }
        switch section {
        case .map:
            return false
        default:
            return true
        }
    }

    var showPaniniCount: Bool {
        guard let section = selectedMenu else { return false }
        switch section {
        case .map:
            return false
        default:
            return true
        }
    }

    var visiblePaniniCount: Int {
        guard let selectedMenu = selectedMenu else { return 0 }
        return selectedMenu.paniniCount(allPanini: allPanini)
    }
}

#Preview {
    HomeView()
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
}
