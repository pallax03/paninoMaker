//
//  PaninoDetailMap.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 10/06/25.
//

import SwiftUI
import MapKit
import MapItemPicker

struct PaninoDetailMap: View {
    @State private var isMapOpen: Bool = false
    @State private var cameraPosition: MapCameraPosition = .automatic


    let panino: Panino
    
    var body: some View {
        Button {
            isMapOpen = true
        } label: {
            if panino.coordinates != nil {
                Map(position: $cameraPosition) {
                    Annotation(panino.name, coordinate: panino.coordinates!) {
                        Text("🍔")
                            .font(.title)
                    }
                }
                .frame(height: 150)
                .cornerRadius(10)
            } else {
                Label("Imposta la posizione", systemImage: "mappin")
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .foregroundStyle(.green)
        .mapItemPickerSheet(isPresented: $isMapOpen) { mapItem in
            panino.setCoordinates(mapItem.location)
        }
    }
}

#Preview {
    CardWrapper(title: "Mappa", color: .green) {
        PaninoDetailMap(panino: Panino())
    }
    .environmentObject(UserModel())
    .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
