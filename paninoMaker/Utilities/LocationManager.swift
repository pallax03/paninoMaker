//
//  LocationManager.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import Foundation
import CoreLocation
import MapKit
import _MapKit_SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var position: MapCameraPosition = .automatic

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
           DispatchQueue.main.async {
               let region = MKCoordinateRegion(
                   center: coordinate,
                   span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
               )
               self.position = .region(region)
            }
        }
    }
}

