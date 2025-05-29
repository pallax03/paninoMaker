//
//  PaninoContent.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI
import SwiftData

struct PaninoContent: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var panini: [Panino]
    @Binding var selectedPanino: Panino?
    var menu: Menu
    
    var body: some View {
        List(menu.panini, selection: $selectedPanino) { panino in
            NavigationLink(value: panino) {
                PaninoRow(panino: panino)
            }
        }
        .navigationTitle(menu.name)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    let panino = Panino(
                        name: "Panino \(panini.count+1)",
                        ingredients: IngredientStore().generateRandoms(count: Int.random(in: 1...10))
                    )
                    modelContext.insert(panino)
                }) {
                    Label("Add panino", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    let panini = PreviewData.samplePanini
    let menuTest = Menu(name: "Test", panini: panini)
    PaninoContent(selectedPanino: .constant(nil), menu: menuTest)
}
