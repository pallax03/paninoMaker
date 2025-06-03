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
                    
                    Text(panino.creationDate.formatted(date: .numeric, time: .standard))
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(panino.owner ?? "no user")
            }
        }
    }
}

//#Preview {
//    PaninoRow(
//            panino: {
//                let panino = Panino(name: "Test")
//                panino.addImage(UIImage(imageLiteralResourceName: "token"))
//                return panino
//            }()
//        )
//        .environmentObject(UserModel())
//}
