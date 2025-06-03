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
    
    @State private var selectedMenuForRestore: Menu?
    @State private var isShowingMoveAllSheet = false
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
                    
                    if showRecycleBinButton {
                        Button {
                            isShowingMoveAllSheet = true
                        } label: {
                            Text("Move All")
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
                    if showRecycleBinButton {
                        Button {
                            for panino in allPanini where panino.isDeleted {
                                modelContext.delete(panino)
                            }
                        } label: {
                            Text("Delete All")
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .sheet(isPresented: $isShowingMoveAllSheet) {
                    MovePaniniSheet(
                        onSelect: { menu in
                            for panino in allPanini where panino.isDeleted {
                                panino.isDeleted = false
                                panino.menu = menu
                            }
                        },
                        onNewMenu: {
                            isShowingNewMenuAlert = true
                        },
                        isPresented: $isShowingMoveAllSheet)
                }
            }
        }
    }
    
    var isBottomBarVisible: Bool {
        if selectedPanino != nil { return false }
        guard let section = selectedMenu else { return true }
        switch section {
        case .map, .profile:
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
        case .map, .trash:
            return false
        default:
            return true
        }
    }
    
    var showRecycleBinButton: Bool {
        guard let section = selectedMenu else { return false }
        switch section {
        case .trash:
            return !allPanini.filter { $0.isDeleted }.isEmpty
        default:
            return false
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
    
    Text("Saved - no panino")
    BottomBar(selectedMenu: .constant(.saved), selectedPanino: .constant(nil))
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
    
    Text("Saved - panino")
    BottomBar(selectedMenu: .constant(.saved), selectedPanino: .constant(panino))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("Recycle Bin")
    BottomBar(selectedMenu: .constant(.trash), selectedPanino: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
    Text("Recycle Bin - panino")
    BottomBar(selectedMenu: .constant(.trash), selectedPanino: .constant(panino))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
    
}
