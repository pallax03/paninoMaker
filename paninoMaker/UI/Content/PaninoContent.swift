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
        VStack(spacing: 0 ) {
            List(selection: $selectedPanino) {
                ForEach(visiblePanini, id: \.self) { panino in
                    NavigationLink(value: panino) {
                        PaninoRow(panino: panino)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            panino.isSaved.toggle()
                        } label: {
                            Label("Saved", systemImage: panino.isSaved ? "bookmark.slash.fill" : "bookmark.fill")
                        }
                        .tint(.orange)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            panino.sendToTrash()
                            try? modelContext.save()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            paninoToMove = panino
                            isShowingMoveSheet = true
                        } label: {
                            Label("Move", systemImage: "folder.fill")
                        }
                        .tint(.indigo)
                        Button {
                            #warning("todo")
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        .tint(.blue)
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
}
