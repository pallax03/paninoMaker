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
//                    Marker(panino.name, coordinate: panino.coordinates!)
//                            .tint(.orange)
                    Annotation(panino.name, coordinate: panino.coordinates!) {
                        Button {
                            selectedPanino = panino
                        } label: {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.orange)
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

//#Preview {
//    MapView(panini: PreviewData.samplePanini)
//}
