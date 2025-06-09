//
//  MapView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    var panini: [Panino]
    @Binding var selectedPanino: Panino?
    @StateObject private var locationManager = LocationManager()

        var body: some View {
            Map(position: $locationManager.position) {
                UserAnnotation()
                
                ForEach(panini) { panino in
                    Annotation(panino.name, coordinate: panino.coordinates!) {
                        NavigationLink {
                            PaninoDetail(panino: panino)
                        } label: {
                            Text("🍔")
                                .font(.title)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.topBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Label("Profile", systemImage: "person.crop.circle")
                            .font(.title)
                    }
                }
            }
        }
}

#Preview {
    NavigationStack {
        MapView(panini: PreviewData.samplePanini, selectedPanino: .constant(PreviewData.samplePanini.first))
    }
    .environmentObject(UserModel())
    .modelContainer(PreviewData.makeModelContainer())
}
