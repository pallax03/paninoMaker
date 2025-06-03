//
//  MapView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager()

        var body: some View {
            Map(position: $locationManager.position) {
                UserAnnotation()
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
    MapView()
}
