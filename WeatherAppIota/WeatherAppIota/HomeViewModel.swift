//
//  HomeViewModel.swift
//  WeatherAppIota
//
//  Created by Kendall Poindexter on 5/27/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import CoreLocation

final class HomeViewModel: NSObject {
   private let locationManager = CLLocationManager()
    
    func setLocationManagerDelegate() {
        locationManager.delegate = self
    }
    
    func requestLocation() {
        requestAuthorization {
            locationManager.requestLocation()
        }
    }
    
    private func requestAuthorization(completion: () -> Void) {
        locationManager.requestWhenInUseAuthorization()
        completion()
    }
}

extension HomeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude else { return }
        print(latitude)
        print(longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //I'd add this error to a generic error alert
        print(error)
    }
}
