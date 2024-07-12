//
//  HomeViewModel.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/11/24.
//

import Foundation

final class HomeViewModel {
    
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
    
    var mainOutput = Observable<MainOutput?>(nil)
    var outputWeather = Observable<WeatherResult?>(nil)
    
    init() {
        outputWeather.bind { result in
            guard let result else { return }
            let name = result.name
            let temp = result.main.temp - 273.15
            guard let description = result.weather.first?.description else { return }
            let tempMin = result.main.tempMin - 273.15
            let tempMax = result.main.tempMax - 273.15
            self.mainOutput.value = MainOutput(cityname: name, temp: temp, description: description, tempMin: tempMin, tempMax: tempMax)
        }
        
        WeatherManager.shared.callRequest(cityId: 1835847) { result in
            self.outputWeather.value = result
        }
    }
    
}
