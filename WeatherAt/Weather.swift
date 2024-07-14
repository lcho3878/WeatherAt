//
//  Weather.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/10/24.
//

import Foundation
import UIKit

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
//        let type: Int
//        let id: Int
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
    
    var dailyList: [Dictionary<String, (Double, Double, URL?)>.Element] {
        var dailyList: [String: (Double, Double, URL?)] = [:]
        for forecast in list {
            let date = forecast.date.dateString("y-M-d")
            let tempMin = forecast.main.tempMin
            let tempMax = forecast.main.tempMax
            if let data = dailyList[date] {
                let hour = Calendar.current.component(.hour, from: forecast.date)
                dailyList[date]?.0 = min(data.0, tempMin)
                dailyList[date]?.1 = max(data.1, tempMax)
                if hour == 12 {
                    dailyList[date]?.2 = forecast.iconImageURL
                }
            }
            else {
                dailyList[date] = (tempMin, tempMax, forecast.iconImageURL)
            }
        }
        return dailyList.sorted { $0.key < $1.key }
    }
    
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
        let rain :WeatherResult.Rain?
        let snow: WeatherResult.Snow?
        
        var date: Date {
            let timeInterval = TimeInterval(dt)
            let date = Date(timeIntervalSince1970: timeInterval)
            return date
        }
        
        var dtText: String {
            return date.dateString("HH시")
        }
        
        var iconImageURL: URL? {
            guard let icon = weather.first?.icon else { return nil }
            return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        }
        
    }
}


