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
        VStack(spacing: 0 ) {
            List(panini, selection: $selectedPanino) { panino in
                NavigationLink(value: panino) {
                    PaninoRow(panino: panino)
                }
            }
            .navigationTitle(title)
        }
    }
}

#Preview {
    let panini = PreviewData.samplePanini
    let menu = Menu(title: "Test", panini: panini)
    PaninoContent(title: menu.title, panini: panini, selectedPanino: .constant(nil), selectedMenu: nil)
}
