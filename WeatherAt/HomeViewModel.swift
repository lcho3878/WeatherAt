//
//  HomeViewModel.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/11/24.
//

import Foundation

final class HomeViewModel {
        
    var mainOutput = Observable<MainOutput?>(nil)
    var outputWeather = Observable<WeatherResult?>(nil)
    var outputForecast = Observable<ForecastResult?>(nil)
    
    init() {
        outputWeather.bind { result in
            guard let result else { return }
            let name = result.name
            let temp = result.main.temp
            guard let description = result.weather.first?.description else { return }
            let tempMin = result.main.tempMin
            let tempMax = result.main.tempMax
            self.mainOutput.value = MainOutput(cityname: name, temp: temp, description: description, tempMin: tempMin, tempMax: tempMax)
        }
        
        WeatherManager.shared.callRequest(api: .current(cityId: 1835847), type: WeatherResult.self){ result in
            self.outputWeather.value = result
        }
        
        WeatherManager.shared.callRequest(api: .forecast(cityId: 1835847), type: ForecastResult.self) { result in
            self.outputForecast.value = result
        }
    }
    
}

extension HomeViewModel {
    struct MainOutput {
        var cityname: String
        var temp: Double
        var description: String?
        var tempMin: Double
        var tempMax: Double
        
        var tempLabel: String {
            return "\(temp.roundUp(demical: 1))°"
        }
         
        var minmaxLabel: String {
            return "최고 : \(tempMax.roundUp(demical: 1))° | 최저 : \(tempMin.roundUp(demical: 1))°"
        }

    }
}
