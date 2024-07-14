//
//  WeatherManager.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/11/24.
//

import Foundation
import Alamofire

final class WeatherManager {
    
    static let shared = WeatherManager()
    
    private init() {}
    
    func callRequest<T: Decodable>(api: WeatherRequest, type: T.Type, completionHandler: @escaping (T) -> Void) {
        guard let url = api.endPoint else { return }
        let params = api.parameters
        AF.request(url, parameters: params)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let v):
                    completionHandler(v)
                case .failure(let e):
                    print(e)
                }
            }
    }
    
}

enum WeatherRequest {
    case currentID(cityId: Int)
    case currentCoord(lat: Double, lon: Double)
    case forecastID(cityId: Int)
    case forecastCoord(lat: Double, lon: Double)
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var endPoint: URL? {
        switch self {
        case .currentID, .currentCoord:
            return URL(string: baseURL + "weather")
        case .forecastID, .forecastCoord:
            return URL(string: baseURL + "forecast")
        }
    }
    
    var parameters: Parameters {
        var params: Parameters = [
            "appid": APIKey.weatherAPI,
            "lang": "kr",
            "units": "metric"
        ]
        switch self {
        case .currentID(let cityId), .forecastID(let cityId):
            params["id"] = cityId
        case .currentCoord(let lat, let lon), .forecastCoord(let lat, let lon):
            params["lat"] = lat
            params["lon"] = lon
        }
        return params
    }
}
