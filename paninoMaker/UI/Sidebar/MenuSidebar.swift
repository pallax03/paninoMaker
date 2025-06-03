//
//  MenuSidebar.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 29/05/25.
//

import SwiftUI
import SwiftData



struct MenuSidebar: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Menu.position, order: .forward) var allMenus: [Menu]
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Binding var selectedMenu: SidebarSection?
    
    var body: some View {
        List(selection: $selectedMenu) {
            Section {
                ForEach([SidebarSection.all, .saved, .map, .trash], id: \.self) { section in
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
                                menu.deletePanini()
                                modelContext.delete(menu)
                            } label: {
                                Label("Delete Menu", systemImage: "trash")
                            }
                            Button() {
                                
                            } label: {
                                Label("Share Menu", systemImage: "square.and.arrow.up")
                            }
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                            let menu = allMenus[index]
                            menu.deletePanini()
                            modelContext.delete(menu)
                    }
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
            ToolbarItem(placement: ToolbarItemPlacement.topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: ToolbarItemPlacement.topBarTrailing) {
                Button(action: { selectedMenu = .profile }) {
                    Label("Profile", systemImage: "person.crop.circle")
                        .font(.title)
                }
            }
        }
    }
}

#Preview {
    MenuSidebar(selectedMenu: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
