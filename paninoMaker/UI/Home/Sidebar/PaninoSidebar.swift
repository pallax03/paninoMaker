//
//  PaninoSidebar.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 29/05/25.
//

import SwiftUI
import SwiftData

enum SidebarSection: Hashable {
    case all
    case map
    case imported
    case trash
    case menus(Menu)
    
    var menu: Menu? {
        if case let .menus(menu) = self {
            return menu
        }
        return nil
    }

    var title: String {
        switch self {
        case .all: return "All Panini"
        case .map: return "Map"
        case .imported: return "Imported"
        case .trash: return "Recycle Bin"
        case .menus(let menu): return menu.title
        }
    }

    var systemImageName: String {
        switch self {
        case .all: return "folder"
        case .map: return "map"
        case .imported: return "square.and.arrow.down"
        case .trash: return "trash"
        case .menus: return "folder"
        }
    }

    func filteredPanini(allPanini: [Panino]) -> [Panino] {
        switch self {
        case .all, .imported:
            return allPanini.filter { !$0.isDeleted }
        case .map:
            return allPanini.filter { $0.coordinates != nil && !$0.isDeleted }
        case .trash:
            return allPanini.filter { $0.isDeleted }
        case .menus(let menu):
            return allPanini.filter { $0.menu == menu && !$0.isDeleted }
        }
    }

    func paniniCount(allPanini: [Panino]) -> Int {
        filteredPanini(allPanini: allPanini).count
    }
    
}

struct PaninoSidebar: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Menu.position, order: .forward) var allMenus: [Menu]
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Binding var selectedMenu: SidebarSection?
    
    var body: some View {
        List(selection: $selectedMenu) {
            Section {
                ForEach([SidebarSection.all, .map, .imported, .trash], id: \.self) { section in
                        MenuRow(
                            title: section.title,
                            systemImageName: section.systemImageName,
                            count: section.paniniCount(allPanini: allPanini)
                        )
                        .tag(section)
                }
            }
            Section("Your Menu") {
                ForEach(allMenus) { menu in
                    let section = SidebarSection.menus(menu)
                        MenuRow(
                            title: SidebarSection.menus(menu).title,
                            systemImageName: SidebarSection.menus(menu).systemImageName,
                            count: SidebarSection.menus(menu).paniniCount(allPanini: allPanini),
                        ).tag(section)
                    .contextMenu {
                        Button(role: .destructive) {
                            // Cancellazione a cascata manuale
                            for panino in menu.panini {
                                modelContext.delete(panino)
                            }
                            modelContext.delete(menu)
                            try? modelContext.save()
                        } label: {
                            Label("Delete Menu", systemImage: "trash")
                        }
                        Button() {
                            // Azione di condivisione
                        } label: {
                            Label("Share Menu", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let menu = allMenus[index]
                        for panino in menu.panini {
                            modelContext.delete(panino)
                        }
                        modelContext.delete(menu)
                    }
                    try? modelContext.save()
                }
                .onMove { fromOffsets, toOffset in
                    var reordered = allMenus
                    reordered.move(fromOffsets: fromOffsets, toOffset: toOffset)
                    for (index, menu) in reordered.enumerated() {
                        menu.position = index
                    }
                    try? modelContext.save()
                }
            }
        }
        .navigationTitle("Menu's")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
        }
    }
}

#Preview {
    PaninoSidebar(selectedMenu: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
