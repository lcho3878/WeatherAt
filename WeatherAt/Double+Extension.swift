//
//  Double+Extension.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/12/24.
//

import Foundation

extension Double {
    func roundUp(demical: Int) -> Double {
        let result = (self * pow(10, Double(demical))).rounded() / pow(10, Double(demical))
        return result
    }
}
