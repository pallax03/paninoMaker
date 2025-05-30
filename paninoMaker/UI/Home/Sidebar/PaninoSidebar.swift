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
    case menus(Menu)
}



struct PaninoSidebar: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Menu.title, order: .forward) var allMenus: [Menu]
    @Binding var selectedMenu: SidebarSection?
    
    var body: some View {
        List(selection: $selectedMenu) {
            Section {
                Button("All panini") {
                    selectedMenu = .all
                }
                Button("Map") {
                    selectedMenu = .map
                }
                Button("Imported") {
                    selectedMenu = .imported
                }
            }
            Section("I tuoi menù") {
                ForEach(allMenus) { menu in
                    Button(menu.title) {
                        selectedMenu = .menus(menu)
                    }
                }
            }
        }
        .navigationTitle("Menu's")
    }
}

#Preview {
    PaninoSidebar(selectedMenu: .constant(nil))
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
