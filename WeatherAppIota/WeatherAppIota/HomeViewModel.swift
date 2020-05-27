//
//  HomeViewModel.swift
//  WeatherAppIota
//
//  Created by Kendall Poindexter on 5/27/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import CoreLocation

protocol HomeViewModelDelegate: AnyObject {
    func reloadUI()
}

final class HomeViewModel: NSObject {
    private let locationManager = CLLocationManager()
    private let networkManager = NetworkManager()
    private(set) var weatherForcast: WeatherResponse?
    private(set) var placeName: (String, String)?
    
    weak var delegate: HomeViewModelDelegate?
    
    var city: String {
        placeName?.0 ?? ""
    }
    
    var state: String {
        placeName?.1 ?? ""
    }
    
    var currentWeatherDescription: String {
        weatherForcast?.current.weather.first?.shortDescription ?? ""
    }
    
    var currentTemp: Double {
        weatherForcast?.current.temp ?? 0
    }
    
    var dailyWeatherForcasts: [DailyWeatherForcast] {
        weatherForcast?.daily ?? []
    }
    
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
    
    private func getPlaceName(with location: CLLocation, completion: @escaping (Result<(String, String), Error>) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
            } else if let placeMark = placemarks?.last {
                guard let city = placeMark.locality else { return }
                guard let state = placeMark.administrativeArea else { return }
                let placeName = (city, state)
                completion(.success(placeName))
            }
        }
    }
}

extension HomeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
         let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        
        networkManager.fetchWeatherResponse(with: latitude, lon: longitude) { result in
            switch result {
            case .success(let weatherResponse):
                
                self.getPlaceName(with: location) { result in
                    switch result {
                    case .success(let place):
                        self.placeName = place
                        self.delegate?.reloadUI()
                    case .failure(let error):
                        //Create error alert
                        print(error)
                    }
                }
                
                self.weatherForcast = weatherResponse
                DispatchQueue.main.async {
                    self.delegate?.reloadUI()
                }
            case .failure(let error):
                // create an error alert to show the user something went wrong
                print(error.localizedDescription)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //I'd add this error to a generic error alert
        print(error)
    }
}
