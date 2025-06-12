//
//  BottomBar.swift
//  paninoMaker
//
//  Created by alex mazzoni on 03/06/25.
//

import SwiftUI
import SwiftData

struct BottomBar: View {
    @EnvironmentObject var user: UserModel
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Query(sort: \MenuModel.position, order: .forward) var allMenus: [MenuModel]
    @Binding var selectedMenu: SidebarSection?
    @Binding var selectedPanino: Panino?
    @Binding var isShowingMoveSheet: Bool
    @Binding var isShowingNewMenuAlert: Bool
    @Binding var newMenuTitle: String
    @Binding var paniniToMove: [Panino]?
    
    
    @State private var selectedMenuForRestore: MenuModel?
    @State private var isShowingMoveAllSheet = false
    
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
                    
                    if showDeleteButton {
                        Button {
                            paniniToMove = allPanini.filter { $0.inTrash }
                            isShowingMoveSheet = true
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
                                owner: user.username, menu: selectedMenu?.menu
                            )
                            if selectedMenu == .saved {
                                panino.isSaved = true
                            }
                            selectedPanino = panino
                            modelContext.insert(panino)
                            try? modelContext.save()
                            GamificationManager.shared.recalculateAll(panini: allPanini)
                        } label: {
                            Image(systemName: "plus")
                                .imageScale(.large)
                        }
                    }
                    if showDeleteButton {
                        Button {
                            for panino in allPanini where panino.inTrash {
                                modelContext.delete(panino)
                            }
                            try? modelContext.save()
                            GamificationManager.shared.recalculateAll(panini: allPanini)
                        } label: {
                            Text("Delete All")
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
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
    
    var showDeleteButton: Bool {
        guard let section = selectedMenu else { return false }
        switch section {
        case .trash:
            return !allPanini.filter { $0.inTrash }.isEmpty
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
    let container = PreviewData.makeModelContainer(withSampleData: true)
    let userModel = UserModel()
    
    let previews: [(label: String, menu: SidebarSection?, panino: Panino?)] = [
            ("Menu Sidebar", nil, nil),
            ("Profile", .profile, nil),
            ("Map", .map, panino),
            ("Saved - no panino", .saved, nil),
            ("PaninoContent all - nopanino", .all, nil),
            ("PaninoContent menu - nopanino", .menus(menu), nil),
            ("PaninoDetail", .menus(menu), panino),
            ("Saved - panino", .saved, panino),
            ("Recycle Bin", .trash, nil),
            ("Recycle Bin - panino", .trash, panino)
        ]
    
    ForEach(Array(previews.enumerated()), id: \.offset) { _, preview in
            VStack {
                Text(preview.label)
                makeBottomBar(
                    selectedMenu: preview.menu,
                    selectedPanino: preview.panino,
                    container: container,
                    userModel: userModel
                )
            }
        }
}

@ViewBuilder
func makeBottomBar(
    selectedMenu: SidebarSection?,
    selectedPanino: Panino?,
    container: ModelContainer,
    userModel: UserModel
) -> some View {
    BottomBar(
        selectedMenu: .constant(selectedMenu),
        selectedPanino: .constant(selectedPanino),
        isShowingMoveSheet: .constant(false),
        isShowingNewMenuAlert: .constant(false),
        newMenuTitle: .constant("New Menu"),
        paniniToMove: .constant(nil)
    )
    .modelContainer(container)
    .environmentObject(userModel)
}
