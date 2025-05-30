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
}



struct PaninoSidebar: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Menu.position, order: .forward) var allMenus: [Menu]
    @Binding var selectedMenu: SidebarSection?
    
    var body: some View {
        List(selection: $selectedMenu) {
            Section {
                Button(action: {selectedMenu = .all }) {
                    Label("All Panini", systemImage: "folder")
                }
                Button(action: {selectedMenu = .map }) {
                    Label("Map", systemImage: "map")
                }
                Button(action: {selectedMenu = .imported }) {
                    Label("Imported", systemImage: "square.and.arrow.down")
                }
                Button(action: {selectedMenu = .trash }) {
                    Label("Recycle Bin", systemImage: "trash")
                }
            }
            Section("Your Menu") {
                ForEach(allMenus) { menu in
                    Button(action: {selectedMenu = .menus(menu) }) {
                        Label(menu.title, systemImage: "folder")
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let menu = allMenus[index]
                        for panino in menu.panini {
                            panino.isDeleted = true
                        }
                        modelContext.delete(menu)
                    }
                }
                .onMove { from, to in
                    var reordered = allMenus
                    reordered.move(fromOffsets: from, toOffset: to)
                    for (index, menu) in reordered.enumerated() {
                        menu.position = index
                    }
                    try? modelContext.save()
                }
            }
        }
        .navigationTitle("Menu's")
        .toolbar{
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
