//
//  NetworkManager.swift
//  WeatherAppIota
//
//  Created by Kendall Poindexter on 5/27/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    func fetchWeatherResponse(with lat: Double,
                              lon: Double,
                              completion: @escaping (Result<WeatherResponse,Error>) -> Void) {
        let urlString = """
                    https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=imperial&exclude=minutely,hourly&appid=5eae362e1dbc9c3adc8bd6e4825e9a5a
                    """
        
        fetchObject(urlString: urlString, type: WeatherResponse.self) { result in
            switch result {
            case .success(let weatherResponse):
                completion(.success(weatherResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchObject<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse,
                200...299 ~= httpResponse.statusCode,
                let data = data {
                
                do {
                let decodedData = try self.decodeData(with: data, type: type )
                    completion(.success(decodedData))
                }catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    private func decodeData<T: Decodable>(with data: Data, type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(type, from: data)
        return decodedData
    }
}
