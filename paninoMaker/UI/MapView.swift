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
            .edgesIgnoringSafeArea(.all)
        }
}

#Preview {
    MapView()
}
