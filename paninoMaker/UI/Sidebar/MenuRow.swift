//
//  MenuRow.swift
//  paninoMaker
//
//  Created by alex mazzoni on 30/05/25.
//

import SwiftUI

struct MenuRow: View {
    var title: String = "All Panini"
    var systemImageName: String = "folder"
    var count: Int = 0
    
    var body: some View {
        HStack {
            Label(title, systemImage: systemImageName)
            Spacer()
            Text("\(count)")
            Image(systemName: "chevron.right")
        }
    }
}

#Preview {
    MenuRow()
}
