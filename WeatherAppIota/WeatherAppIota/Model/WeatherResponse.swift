//
//  WeatherResponse.swift
//  WeatherAppIota
//
//  Created by Kendall Poindexter on 5/27/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    let current: CurrentForcast
    let daily: [DailyWeatherForcast]
}

struct CurrentForcast: Decodable {
    let temp: Double
    let weather: [WeatherDescription]
}

struct DailyWeatherForcast: Decodable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
    }
    
    static func == (lhs: DailyWeatherForcast, rhs: DailyWeatherForcast) -> Bool {
        lhs.day == rhs.day
    }
    
    let day: Double
    let temp: TemperatureResponse
    let weather: [WeatherDescription]
    
    enum CodingKeys: String, CodingKey {
        case day = "dt"
        case temp
        case weather
    }
}

struct TemperatureResponse: Decodable {
    let lowTemp: Double
    let highTemp: Double
    
    enum CodingKeys: String, CodingKey {
        case lowTemp = "min"
        case highTemp = "max"
    }
}

struct WeatherDescription: Decodable {
    let shortDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case shortDescription = "main"
        case icon
    }
}
