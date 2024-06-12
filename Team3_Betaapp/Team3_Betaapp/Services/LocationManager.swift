//
//  LocationManager.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 11/1/23.
//

import Foundation
import CoreLocation

class LocationManager1: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager1 = CLLocationManager()
    @Published var lastLocation1: CLLocation? // The most recent location obtained by the location manager.
    
    override init() {
        super.init()
        self.locationManager1.delegate = self
        self.locationManager1.requestWhenInUseAuthorization() // Request permission to use location services.
        self.locationManager1.startUpdatingLocation() // Start updating the location.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation1 = locations.last // Update the lastLocation1 property with the most recent location.
    }
}
