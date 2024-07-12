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
    
    func callRequest(cityId: Int, completionHandler: @escaping (WeatherResult) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let params: Parameters = [
            "appid": APIKey.weatherAPI,
            "id": cityId,
            "lang": "kr",
            "units": "metric"
        ]
        AF.request(url, parameters: params)
            .responseDecodable(of: WeatherResult.self) { response in
                switch response.result {
                case .success(let v):
                    completionHandler(v)
                case .failure(let e):
                    print(e)
                }
            }
    }
    
}
