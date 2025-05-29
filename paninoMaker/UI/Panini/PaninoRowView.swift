//
//  PaninoRowView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI

struct PaninoRowView: View {
    @EnvironmentObject var user: UserModel
    
    let panino: Panino
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
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
        .padding()
    }
}

#Preview {
    PaninoRowView(panino: Panino(name: "Test"))
        .environmentObject(UserModel())
}
