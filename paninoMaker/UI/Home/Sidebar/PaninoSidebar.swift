//
//  PaninoSidebar.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 29/05/25.
//

import SwiftUI

struct PaninoSidebar: View {
    @StateObject private var model = DataModel()
    @Binding var selectedMenu: Menu?
    
    var body: some View {
        VStack {
            List(model.menus, selection: $selectedMenu) { menu in
                NavigationLink(value: menu) {
                    Text(menu.name)
                }
            }
        }
        .navigationTitle("Menu")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
            }
        }
    }
}

#Preview {
    PaninoSidebar(selectedMenu: .constant(nil))
}
