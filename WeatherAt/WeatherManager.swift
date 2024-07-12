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
                    print("Success: \(T.self)")
                    completionHandler(v)
                case .failure(let e):
                    print(e)
                }
            }
    }
    
}

enum WeatherRequest {
    case current(cityId: Int)
    case forecast(cityId: Int)
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var endPoint: URL? {
        switch self {
        case .current:
            return URL(string: baseURL + "weather")
        case .forecast:
            return URL(string: baseURL + "forecast")
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .current(let cityId):
            return [
                "appid": APIKey.weatherAPI,
                "id": cityId,
                "lang": "kr",
                "units": "metric"
            ]
        case .forecast(let cityId):
            return [
                "appid": APIKey.weatherAPI,
                "id": cityId,
                "lang": "kr",
                "units": "metric"
            ]
        }
    }
}
