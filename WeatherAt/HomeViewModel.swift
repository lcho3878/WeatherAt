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
    
    init() {
        callRequest(1835847)
        requestInput.bind { id in
            guard let id else { return }
            self.callRequest(id)
        }

    }
    
    private func callRequest(_ id: Int) {
        WeatherManager.shared.callRequest(api: .current(cityId: id), type: WeatherResult.self){ result in
            self.outputWeather.value = result
        }
        
        WeatherManager.shared.callRequest(api: .forecast(cityId: id), type: ForecastResult.self) { result in
            self.outputForecast.value = result
        }
    }
    
}
