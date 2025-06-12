//
//  SidebarSection.swift
//  paninoMaker
//
//  Created by alex mazzoni on 03/06/25.
//


import SwiftUI
import SwiftData

enum SidebarSection: Hashable {
    case all
    case saved
    case nopex
    case map
    case trash
    case profile
    case menus(MenuModel)
    
    var menu: MenuModel? {
        if case let .menus(menu) = self {
            return menu
        }
        return nil
    }
    
    var title: String {
        switch self {
        case .all: return "Tutti i Panini"
        case .nopex: return "Zero PEX"
        case .saved: return "Salvati"
        case .map: return "Mappa"
        case .trash: return "Cestino"
        case .menus(let menu): return menu.title
        default: return ""
        }
    }
    
    var systemImageName: String {
        switch self {
        case .all: return "folder"
        case .nopex: return "exclamationmark.triangle"
        case .saved: return "bookmark"
        case .map: return "map"
        case .trash: return "trash"
        case .menus: return "folder"
        default: return "xmark"
        }
    }
    
    func filteredPanini(allPanini: [Panino], searchPanino: String = "") -> [Panino] {
        let searchedPanini = allPanini.filter { ( searchPanino.isEmpty ||  $0.name.localizedCaseInsensitiveContains(searchPanino) ) }
        let noTrashedPanini = searchedPanini.filter { !$0.inTrash }
        switch self {
        case .all:
            return noTrashedPanini
        case .nopex:
            return noTrashedPanini.filter { $0.pex == 0 }
        case .saved:
            return noTrashedPanini
        case .map:
            return allPanini.filter { $0.coordinates != nil && !$0.inTrash }
        case .trash:
            return searchedPanini.filter { $0.inTrash }
        case .menus(let menu):
            return noTrashedPanini.filter { $0.menu == menu }
        default:
            return []
        }
    }
    
    func paniniCount(allPanini: [Panino]) -> Int {
        filteredPanini(allPanini: allPanini).count
    }
    
    @ViewBuilder
    func makeContentView(
        panini: [Panino],
        selectedPanino: Binding<Panino?>,
        selectedMenu: Binding<SidebarSection?>,
        isShowingMoveSheet: Binding<Bool>,
        isShowingNewMenuAlert: Binding<Bool>,
        newMenuTitle: Binding<String>,
        paniniToMove: Binding<[Panino]?>,
        searchPanino: Binding<String>,
    ) -> some View {
        switch self {
        case .map:
            MapView(panini: panini, selectedPanino: selectedPanino)
        case .profile:
            ProfileView()
        default:
            let isTrashView = (self == .trash)
            PaninoContent(
                paniniToMove: paniniToMove,
                title: title,
                panini: panini,
                selectedPanino: selectedPanino,
                selectedMenu: selectedMenu,
                isShowingMoveSheet: isShowingMoveSheet,
                isShowingNewMenuAlert: isShowingNewMenuAlert,
                newMenuTitle: newMenuTitle,
                isTrash: isTrashView
            )
            .searchable(
                text: searchPanino,
                placement: .navigationBarDrawer
            )
        }
    }
}
