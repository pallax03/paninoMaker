//
//  PaninoContent.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI
import SwiftData

struct PaninoContent: View {
    @EnvironmentObject var user: UserModel
    @Environment(\.modelContext) var modelContext
    @Binding var paninoToMove: Panino?
    @State var isShowingMoveSheet: Bool = false
    var title: String
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    var panini: [Panino]
    @Binding var selectedPanino: Panino?
    @Binding var selectedMenu: SidebarSection?
    @Binding var isShowingNewMenuAlert: Bool
    @Binding var newMenuTitle: String
    
    var isTrash: Bool = false
    
    var visiblePanini: [Panino] {
        panini.filter { $0.inTrash == isTrash }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            List(selection: $selectedPanino) {
                ForEach(visiblePanini, id: \.self) { panino in
                    NavigationLink(value: panino) {
                        PaninoRow(panino: panino)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            panino.isSaved.toggle()
                            try? modelContext.save()
                            GamificationManager.shared.recalculateAll(panini: allPanini)
                        } label: {
                            Label("Saved", systemImage: panino.isSaved ? "bookmark.slash.fill" : "bookmark.fill")
                        }
                        .tint(.orange)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            if selectedMenu == .trash {
                                panino.restoreFromTrash(menu: nil)
                            } else {
                                panino.sendToTrash()
                            }
                            try? modelContext.save()
                            GamificationManager.shared.recalculateAll(panini: allPanini)
                        } label: {
                            Label(selectedMenu == .trash ? "Restore" : "Delete", systemImage: selectedMenu == .trash ? "trash.slash.fill" : "trash.fill")
                        }
                        .tint(selectedMenu == .trash ? .cyan : .red)
                        Button {
                            paninoToMove = panino
                            isShowingMoveSheet = true
                        } label: {
                            Label("Move", systemImage: "folder.fill")
                        }
                        .tint(.indigo)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.topBarTrailing) {
                    Button(action: { selectedMenu = .profile }) {
                        Label("Profile", systemImage: "person.crop.circle")
                            .font(.title)
                    }
                }
            }
            .sheet(isPresented: $isShowingMoveSheet) {
                MovePaniniSheet(
                    onSelect: {menu in
                        if let panino = paninoToMove {
                            panino.restoreFromTrash(menu: menu)
                            try? modelContext.save()
                            GamificationManager.shared.recalculateAll(panini: allPanini)
                        }
                    },
                    onNewMenu: {
                        isShowingMoveSheet = false
                        isShowingNewMenuAlert = true
                    },
                    isPresented: $isShowingMoveSheet
                )
            }
        }
    }
}

#Preview {
    let panini = PreviewData.samplePanini
    let menu = Menu(title: "Test", panini: panini)
    PaninoContent(paninoToMove: .constant(nil), title: menu.title, panini: panini, selectedPanino: .constant(nil), selectedMenu: .constant(nil), isShowingNewMenuAlert: .constant(false), newMenuTitle: .constant(""))
        .environmentObject(UserModel())
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
