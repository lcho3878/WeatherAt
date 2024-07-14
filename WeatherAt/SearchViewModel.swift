//
//  SearchViewModel.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/14/24.
//

import Foundation

final class SearchViewModel {
    
    private var cityList: [City] = []
    
    var viewDidloadInput = Observable<Void?>(nil)
    var searchTextInput = Observable<String>("")
    
    var viewDidloadOutput = Observable<[City]?>(nil)
    
    init() {
        viewDidloadInput.bind { _ in
            guard let data = self.loadData() else { return }
            self.loadCities(data)
            self.viewDidloadOutput.value = self.cityList
        }
        
        searchTextInput.bind { text in
            guard text != "" else {
                self.viewDidloadOutput.value = self.cityList
                return
            }
            let text = text.lowercased()
            self.viewDidloadOutput.value = self.cityList.filter { $0.name.localizedCaseInsensitiveContains(text) || $0.country.localizedCaseInsensitiveContains(text) }
        }
    }
    
    private func loadCities(_ data: Data) {
        guard let data = self.loadData() else { return }
        do {
            let result = try JSONDecoder().decode([City].self, from: data)
            cityList = result
        }
        catch {
            print(error)
        }
    }
    
    private func loadData() -> Data? {
        let fileName = "CityList"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        }
        catch {
            return nil
        }
    }
    
}

extension SearchViewModel {
    struct City: Decodable {
        let id: Int
        let name: String
        let state: String
        let country: String
        let coord: Coord
        
        struct Coord: Decodable {
            let lon: Double
            let lat: Double
        }
    }
}
