//
//  ContentView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MenuView()
    }
}

#Preview {
    ContentView()
        .environmentObject(UserModel())
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
