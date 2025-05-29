//
//  HomeView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var model = DataModel()
    @State var selectedMenu: Menu?
    @State var selectedPanino: Panino?
    
    var body: some View {
        NavigationSplitView(/*preferredCompactColumn: .constant(.content)*/) {
            VStack {
                List(model.menus, selection: $selectedMenu) { menu in
                    NavigationLink(value: menu) {
                        Text(menu.name)
                    }
                }
                
                Spacer()
                
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .padding()
            }
            .navigationTitle("Menu")
        } content: {
            if let menu = selectedMenu {
                PaninoContentView(selectedPanino: $selectedPanino, menu: menu)
            } else {
                Text("Select a menu")
            }
        } detail: {
            if let panino = selectedPanino {
                PaninoDetailsView(panino: panino)
                .padding()
            } else {
                Text("Select an item")
            }
        }
    }
}

class DataModel: ObservableObject {
    @Published var menus: [Menu] = [
        Menu(name: "All", panini: [
            Panino(name: "BigMac"),
            Panino(name: "Cheeseburger"),
        ])
    ]
}

#Preview {
    HomeView().modelContainer(PreviewData.makeModelContainer(withSampleData: true)).environmentObject(UserModel())
}
