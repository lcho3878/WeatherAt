//
//  Weather.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/10/24.
//

import Foundation

struct WeatherResult: Decodable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let rain: Rain?
    let snow: Snow?
    let name: String
    
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        let seaLevel: Int
        let grndLevel: Int
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
        
    }
    
    struct Wind: Decodable {
        let speed: Double
        let deg: Int
    }
    
    struct Clouds: Decodable {
        let all: Int
    }
    
    struct Sys: Decodable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
    
    struct Rain: Decodable {
        let precipitation: Double
        
        enum CodingKeys: String, CodingKey {
            case precipitation = "1h"
        }
    }
    
    struct Snow: Decodable {
        let precipitation: Double
        
        enum CodingKeys: String, CodingKey {
            case precipitation = "1h"
        }
    }
}
