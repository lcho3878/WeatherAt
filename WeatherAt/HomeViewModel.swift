//
//  HomeViewModel.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/11/24.
//

import Foundation

final class HomeViewModel {
        
    var outputWeather = Observable<WeatherResult?>(nil)
    var outputForecast = Observable<ForecastResult?>(nil)
    
    var requestInput = Observable<Int?>(nil)
    var mapViewInput = Observable<[Double]?>(nil)
    
    init() {
        let cityID = UserDefaults.standard.integer(forKey: "cityID")
        callRequest(cityID)
        requestInput.bind { [weak self] id in
            self?.callRequest(id)
        }
        
        mapViewInput.bind { [weak self] coord in
            self?.callRequest(coord)
        }

    }
    
    private func callRequest(_ id: Int?) {
        guard let id else { return }
        WeatherManager.shared.callRequest(api: .currentID(cityId: id), type: WeatherResult.self){ result in
            self.outputWeather.value = try? result.get()
        }
        
        WeatherManager.shared.callRequest(api: .forecastID(cityId: id), type: ForecastResult.self) { result in
            self.outputForecast.value = try? result.get()
        }
    }
    
    private func callRequest(_ coord: [Double]?) {
        guard let lat = coord?[0],
              let lon = coord?[1] else { return }
        WeatherManager.shared.callRequest(api: .currentCoord(lat: lat, lon: lon), type: WeatherResult.self) { result in
            self.outputWeather.value = try? result.get()
        }
        
        WeatherManager.shared.callRequest(api: .forecastCoord(lat: lat, lon: lon), type: ForecastResult.self) { result in
            self.outputForecast.value = try? result.get()
        }
    }
    
}
