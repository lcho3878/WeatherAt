//
//  TranslucentView.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/15/24.
//

import UIKit

final class TranslucentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        backgroundColor = .clear.withAlphaComponent(0.5)
    }
}
