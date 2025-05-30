//
//  HomeView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Query(sort: \Menu.title, order: .reverse) var allMenus: [Menu]
    @State var selectedMenu: SidebarSection?
    @State var selectedPanino: Panino?

    @State private var isShowingNewMenuAlert = false
    @State private var newMenuTitle = ""
    
    var panini: [Panino] { switch selectedMenu {
        case .all, .map:
            return allPanini
        case .imported:
            return []
        case .menus(let menu):
            return menu.panini
        default:
            return []
        }
    }
    
    var body: some View {
        NavigationSplitView(/*preferredCompactColumn: .constant(.content)*/) {
            VStack(spacing: 0) {
                PaninoSidebar(selectedMenu: $selectedMenu)
            }
        } content: {
            VStack(spacing:0) {
                if let section = selectedMenu {
                    switch section {
                    case .all:
                        PaninoContent(title: "All Panini", panini: panini, selectedPanino: $selectedPanino, selectedMenu: nil)
                    case .map:
                        MapView()
                    case .imported:
                        PaninoContent(title: "Imported Panini", panini: panini, selectedPanino: $selectedPanino, selectedMenu: nil)
                    case .menus(let menu):
                        PaninoContent(title: menu.title, panini: panini, selectedPanino: $selectedPanino, selectedMenu: menu)
                    }
                } else {
                    Text("Select a menu")
                }
            }
        } detail: {
            VStack(spacing: 0) {
                if let panino = selectedPanino {
                    PaninoDetail(panino: panino)
                        .padding()
                } else {
                    Text("Select an item")
                }
            }
        }.safeAreaInset(edge: .bottom) {
            bottomBar()
        }
    }
    
    @ViewBuilder
    func bottomBar() -> some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    isShowingNewMenuAlert = true
                } label: {
                    Image(systemName: "folder.badge.plus")
                        .imageScale(.large)
                }
                
                if selectedMenu != nil {
                    Spacer()
                    Text("\(panini.count) Panini")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    selectedMenu = selectedMenu ?? .all
                    let panino = Panino(name: "", menu: (selectedMenu.flatMap {
                        if case let .menus(menu) = $0 { return menu } else { return nil }
                    }))
                    selectedPanino = panino
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
            .padding()
            .background(.clear)
            .alert("Nuovo Menu", isPresented: $isShowingNewMenuAlert) {
                TextField("Nome del menu", text: $newMenuTitle)
                Button("Crea", action: {
                    let menu = Menu(title: newMenuTitle.isEmpty ? "Senza nome" : newMenuTitle, panini: [])
                    modelContext.insert(menu)
                    selectedMenu = .menus(menu)
                    newMenuTitle = ""
                })
                Button("Annulla", role: .cancel) {
                    newMenuTitle = ""
                }
            } message: {
                Text("Inserisci un nome per il nuovo menu.")
            }
        }
    }
}



#Preview {
    HomeView()
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
}
