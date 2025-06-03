//
//  BottomBar.swift
//  paninoMaker
//
//  Created by alex mazzoni on 03/06/25.
//

import SwiftUI
import SwiftData

struct BottomBar: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Query(sort: \Menu.position, order: .forward) var allMenus: [Menu]
    @Binding var selectedMenu: SidebarSection?
    @Binding var selectedPanino: Panino?
    
    @State private var isShowingNewMenuAlert = false
    @State private var newMenuTitle = ""
    
    var body: some View {
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
                    } else {
                        Spacer()
                        Text("\(allMenus.count) Menu")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if showPlusButton {
                        Button {
                            selectedMenu = selectedMenu ?? .all
                            let panino = Panino(
                                name: "New Panino \(allPanini.count + 1)",
                                menu: selectedMenu?.menu
                            )
                            selectedPanino = panino
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
        if selectedPanino != nil { return false }
        guard let section = selectedMenu else { return true }
        switch section {
        case .trash, .map, .profile:
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
    let panino = PreviewData.samplePanino
    let menu = PreviewData.sampleMenu
    
    Text("Menu Sidebar")
    BottomBar(selectedMenu: .constant(nil), selectedPanino: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("Profile")
    BottomBar(selectedMenu: .constant(.profile), selectedPanino: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("Map")
    BottomBar(selectedMenu: .constant(.map), selectedPanino: .constant(panino))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("Favorite - no panino")
    BottomBar(selectedMenu: .constant(.favorite), selectedPanino: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("PaninoContent all - nopanino")
    BottomBar(selectedMenu: .constant(.all), selectedPanino: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("PaninoContent menu - nopanino")
    BottomBar(selectedMenu: .constant(.menus(menu)), selectedPanino: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("PaninoDetail")
    BottomBar(selectedMenu: .constant(.menus(menu)), selectedPanino: .constant(panino))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("Favorite - panino")
    BottomBar(selectedMenu: .constant(.favorite), selectedPanino: .constant(panino))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("Recycle Bin")
    BottomBar(selectedMenu: .constant(.trash), selectedPanino: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("Recycle Bin - panino")
    BottomBar(selectedMenu: .constant(.trash), selectedPanino: .constant(panino))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
}
