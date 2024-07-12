//
//  ForecastCollectionViewCell.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/12/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ForecastCollectionViewCell: BaseCollectionViewCell {
    
    private let contentStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.distribution = .fillEqually
        return view
    }()
    
    private let timeLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    private let weatherIconImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let tempLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 20)
        return view
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(timeLabel)
        contentStackView.addArrangedSubview(weatherIconImageView)
        contentStackView.addArrangedSubview(tempLabel)
    }
    
    override func configureLayout() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }        
    }
    
    func configureData(_ data: ForecastResult.Forecast) {
        timeLabel.text = data.dtText
        weatherIconImageView.kf.setImage(with: data.iconImageURL)
        tempLabel.text = "\(Int(data.main.temp))°"
    }
}
