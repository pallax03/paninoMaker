//
//  PaninoContent.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI
import SwiftData

enum PaninoSortField: String, CaseIterable, Identifiable {
    case points = "PEX"
    case date = "Data"
    case rating = "Rating"
    
    var id: String { self.rawValue }
}

struct PaninoContent: View {
    @EnvironmentObject var user: UserModel
    @Environment(\.modelContext) var modelContext
    @Binding var paniniToMove: [Panino]?
    
    var title: String
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    var panini: [Panino]
    @Binding var selectedPanino: Panino?
    @Binding var selectedMenu: SidebarSection?
    @Binding var isShowingMoveSheet: Bool
    @Binding var isShowingNewMenuAlert: Bool
    @Binding var newMenuTitle: String
    @State private var sortField: PaninoSortField = .date
    @State private var sortAscending: Bool = true
    
    var isTrash: Bool = false
    
    var visiblePanini: [Panino] {
        let filtered = panini.filter { $0.inTrash == isTrash }
        let sorted: [Panino]
        
        switch sortField {
        case .points:
            sorted = filtered.sorted {
                sortAscending ? ($0.pex < $1.pex) : ($0.pex > $1.pex)
            }
        case .date:
            sorted = filtered.sorted {
                sortAscending ? ($0.creationDate < $1.creationDate) : ($0.creationDate > $1.creationDate)
            }
        case .rating:
            sorted = filtered.sorted {
                let rating0 = $0.rating ?? 0
                let rating1 = $1.rating ?? 0
                return sortAscending ? (rating0 < rating1) : (rating0 > rating1)
            }
        }
        
        return sorted
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
                            paniniToMove = [panino]
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
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(PaninoSortField.allCases) { field in
                            Button {
                                if sortField == field {
                                    sortAscending.toggle()
                                } else {
                                    sortField = field
                                    sortAscending = true
                                }
                            } label: {
                                HStack {
                                    Text(field.rawValue)
                                    
                                    if sortField == field {
                                        Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        let panini = PreviewData.samplePanini
        let menu = MenuModel(title: "Test", panini: panini)
        PaninoContent(paniniToMove: .constant(nil), title: menu.title, panini: panini, selectedPanino: .constant(nil), selectedMenu: .constant(.all), isShowingMoveSheet: .constant(false), isShowingNewMenuAlert: .constant(false), newMenuTitle: .constant(""))
    }
    .environmentObject(UserModel())
    .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
