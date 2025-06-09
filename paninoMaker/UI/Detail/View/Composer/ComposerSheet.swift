//
//  ComposerSheet.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData

struct ComposerSheet: View {
    @EnvironmentObject var user: UserModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.ingredientStore) var ingredientStore
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @Environment(\.dismiss) private var dismiss
    @State private var isShown = false
    let panino: Panino
    @State var draftComposer: Composer
    
    var body: some View {
        NavigationStack {
            VStack {
                ComposerBread(draftComposer: $draftComposer.top)
                
                ComposerIngredients(draftComposer: $draftComposer.ingredients)
                
                ComposerBread(draftComposer: $draftComposer.bottom)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        panino.composer = draftComposer
                        GamificationManager.shared.recalculateAll(panini: allPanini)
                        try? modelContext.save()
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

#Preview {
    ComposerSheet(panino: Panino(), draftComposer: Composer())
        .environmentObject(UserModel())
        .modelContainer(PreviewData.makeModelContainer())
}
