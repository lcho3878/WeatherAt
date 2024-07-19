//
//  Base.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/13/24.
//

import Foundation

@objc
protocol Base {
    @objc 
    optional func configureView()
    
    func configureHierarchy()
    
    func configureLayout()
}
