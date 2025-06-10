//
//  MovePaniniSheet.swift
//  paninoMaker
//
//  Created by alex mazzoni on 03/06/25.
//

import SwiftUI
import SwiftData

struct MovePaniniSheet: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \MenuModel.position, order: .forward) var allMenus: [MenuModel]
    var onSelect: (MenuModel?) -> Void
    var onNewMenu: () -> Void
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                Button(SidebarSection.all.title) {
                    onSelect(nil)
                    isPresented = false
                }
                ForEach(allMenus) { menu in
                    Button(menu.title) {
                        onSelect(menu)
                        isPresented = false
                    }
                }

                Section {
                    Button {
                        isPresented = false
                        onNewMenu()
                    } label: {
                        Label("New Menu...", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Move to Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    MovePaniniSheet(
        onSelect: {_ in },
        onNewMenu: { },
        isPresented: .constant(false)
    )
    .environmentObject(UserModel())
    .modelContainer(PreviewData.makeModelContainer())
}
