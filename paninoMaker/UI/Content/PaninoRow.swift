//
//  PaninoRow.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI

struct PaninoRow: View {
    @EnvironmentObject var user: UserModel
    
    let panino: Panino
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ComposerPreview(composer: panino.composer)
                
//                Image(uiImage: panino.images.first!)
//                    .resizable()
//                    .scaledToFit()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    
                    Text(panino.name)
                    
                    Label(panino.menu?.title ?? SidebarSection.all.title, systemImage: "folder.fill")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(panino.owner ?? "no user")
                    Text("\(panino.calculatePoints()) points")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }
}

#Preview {
    PaninoRow(panino: PreviewData.samplePanino)
        .environmentObject(UserModel())
}
