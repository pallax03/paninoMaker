//
//  PaninoDetailComposer.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 09/06/25.
//

import SwiftUI

struct PaninoDetailComposer: View {
    let panino: Panino
    @State private var isComposing: Bool = false

    var body: some View {
        VStack {
            Button {
                isComposing = true
            } label: {
                ComposerPreview(composer: panino.composer)
            }
            .sheet(isPresented: $isComposing, content: {
                ComposerSheet(panino: panino, draftComposer: panino.composer.copy())
            })
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                ForEach(Array(panino.badges).sorted { $0.title < $1.title }, id: \.title) { entity in
                    BadgeView(badge: entity.resolvedBadge!)
                }
            }
        }
    }
}

#Preview {
    CardWrapper(title: "Composer",color: .yellow) {
        PaninoDetailComposer(panino: Panino())
    }
    .environmentObject(UserModel())
    .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
