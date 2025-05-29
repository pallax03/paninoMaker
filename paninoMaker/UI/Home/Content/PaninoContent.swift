//
//  PaninoContent.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI
import SwiftData

struct PaninoContent: View {
    @Environment(\.modelContext) var modelContext
    var title: String
    var panini: [Panino]
    @Binding var selectedPanino: Panino?
    var selectedMenu: Menu?  // opzionale, per assegnare al nuovo panino

    var body: some View {
        List(panini, selection: $selectedPanino) { panino in
            NavigationLink(value: panino) {
                PaninoRow(panino: panino)
            }
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    let panino = Panino(
                        name: "Panino \(panini.count+1)",
                        ingredients: IngredientStore().generateRandoms(count: Int.random(in: 1...10)),
                        menu: selectedMenu
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
    let menu = Menu(title: "Test", panini: panini)
    PaninoContent(title: menu.title, panini: panini, selectedPanino: .constant(nil), selectedMenu: nil)
}
