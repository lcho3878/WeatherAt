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
        let oneHour: Double?
        let threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
    
    struct Snow: Decodable {
        let oneHour: Double?
        let threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
}

struct ForecastResult: Decodable {
    
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Forecast]
    let city: City
    
    struct City: Decodable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
    }
    
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
    
    struct Forecast: Decodable {
        let dt: Int
        let main: WeatherResult.Main
        let weather: [WeatherResult.Weather]
        let clouds: WeatherResult.Clouds
        let wind: WeatherResult.Wind
        let visibility: Int
        let pop: Double // forecast only
        let dtText: String
        let rain :WeatherResult.Rain?
        let snow: WeatherResult.Snow?
        
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop, rain, snow
            case dtText = "dt_txt"
        }
        
    }
}


