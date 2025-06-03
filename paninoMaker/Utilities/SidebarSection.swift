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
    case favorite
    case map
    case trash
    case profile
    case menus(Menu)
    
    var menu: Menu? {
        if case let .menus(menu) = self {
            return menu
        }
        return nil
    }
    
    var title: String {
        switch self {
        case .all: return "All Panini"
        case .favorite: return "Favorites"
        case .map: return "Map"
        case .trash: return "Recycle Bin"
        case .menus(let menu): return menu.title
        default: return ""
        }
    }
    
    var systemImageName: String {
        switch self {
        case .all: return "folder"
        case .favorite: return "heart"
        case .map: return "map"
        case .trash: return "trash"
        case .menus: return "folder"
        default: return ""
        }
    }
    
    func filteredPanini(allPanini: [Panino]) -> [Panino] {
        switch self {
        case .all:
            return allPanini.filter { !$0.isDeleted }
        case .favorite:
            return allPanini.filter { !$0.isDeleted && $0.isFavorite }
        case .map:
            return allPanini.filter { $0.coordinates != nil && !$0.isDeleted }
        case .trash:
            return allPanini.filter { $0.isDeleted }
        case .menus(let menu):
            return allPanini.filter { $0.menu == menu && !$0.isDeleted }
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
        allPanini: [Panino]
    ) -> some View {
        switch self {
        case .all:
            PaninoContent(title: title, panini: panini, selectedPanino: selectedPanino, selectedMenu: selectedMenu, isTrash: false)
        case .map:
            MapView()
        case .favorite:
            PaninoContent(title: title, panini: panini, selectedPanino: selectedPanino, selectedMenu: selectedMenu, isTrash: false)
        case .trash:
            PaninoContent(title: title, panini: panini, selectedPanino: selectedPanino, selectedMenu: selectedMenu, isTrash: true)
        case .menus(_):
            PaninoContent(title: title, panini: panini, selectedPanino: selectedPanino, selectedMenu: selectedMenu, isTrash: false)
        case .profile:
            ProfileView()
        }
    }
}
