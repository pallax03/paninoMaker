//
//  MenuSidebar.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 29/05/25.
//

import SwiftUI
import SwiftData


struct MenuSidebar: View {
    @EnvironmentObject var user: UserModel
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Menu.position, order: .forward) var allMenus: [Menu]
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Binding var selectedMenu: SidebarSection?
    @State private var isShowingRenameMenuAlert = false
    @State private var renameMenuTitle = ""
    @State private var focusedMenu: Menu? = nil
    
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
                                try? modelContext.save()
                                
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                focusedMenu = menu
                                renameMenuTitle = menu.title
                                isShowingRenameMenuAlert.toggle()
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                focusedMenu = menu
                                renameMenuTitle = menu.title
                                isShowingRenameMenuAlert.toggle()
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                            .tint(.indigo)
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let menu = allMenus[index]
                        menu.deletePanini()
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
        .alert("Rename Menu", isPresented: $isShowingRenameMenuAlert) {
            TextField("Title of the menu", text: $renameMenuTitle)
            Button("Rename", action: {
                focusedMenu?.renameMenu(renameMenuTitle)
                try? modelContext.save()
                renameMenuTitle = ""
            })
            Button("Cancel", role: .cancel) {
                renameMenuTitle = ""
            }
        } message: {
            Text("Rename menu title.")
        }
    }
}

#Preview {
    MenuSidebar(selectedMenu: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
}
