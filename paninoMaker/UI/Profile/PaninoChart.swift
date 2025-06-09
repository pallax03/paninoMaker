//
//  PaninoChart.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 07/06/25.
//

import SwiftUI
import Charts

struct PaninoChart: View {
    var allPanini: [Panino]
    
    var body: some View {
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
}

#Preview {
    PaninoChart(allPanini: PreviewData.samplePanini)
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
        .environmentObject(ThemeManager())
}
