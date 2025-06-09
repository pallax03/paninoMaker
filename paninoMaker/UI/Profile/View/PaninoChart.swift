//
//  PaninoChart.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 07/06/25.
//

import SwiftUI
import Charts
import SwiftData

struct PaninoChart: View {
    @Query(filter: #Predicate { !$0.inTrash }, sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]

    var body: some View {
        VStack {
            Text("Your Panino Badges")
                .font(.title)
                .fontWeight(.bold)
            
            Chart(allPanini) { panino in
                LineMark(
                    x: .value("Panino", panino.name),
                    y: .value("Badges", panino.badges.count)
                )
                .foregroundStyle(.blue)
                .symbol(Circle())
            }
            .frame(height: 300)
            .padding()
        }
        .padding()
    }
}

#Preview {
    PaninoChart()
        .modelContainer(PreviewData.makeModelContainer())
        .environmentObject(UserModel())
        .environmentObject(ThemeManager())
}
