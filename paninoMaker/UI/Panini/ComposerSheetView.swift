//
//  ComposerSheet.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct ComposerSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Composer")
            }
            .navigationTitle("Panino #N")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Chiude lo sheet
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Fare qualcosa poi chiudere lo sheet
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
    ComposerSheetView()
}
