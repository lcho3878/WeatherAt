//
//  ForecastTableViewCell.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/12/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ForecastTableViewCell: BaseTableViewCell {
    
    private let contentStackview = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private let dayLabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    private let iconImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    private let minTempLabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    private let maxTempLabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        contentView.addSubview(contentStackview)
        contentStackview.addArrangedSubview(dayLabel)
        contentStackview.addArrangedSubview(iconImageView)
        contentStackview.addArrangedSubview(minTempLabel)
        contentStackview.addArrangedSubview(maxTempLabel)
    }
    
    override func configureLayout() {
        contentStackview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }
    
    func configureData(_ data: Dictionary<String, (Double, Double, URL?)>.Element) {
        guard let date = Date.stringDate(string: data.key, format: "y-M-d") else { return }
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
            dayLabel.text = "오늘"
        }
        else {
            dayLabel.text = date.dateString("E")
        }
        iconImageView.kf.setImage(with: data.value.2)
        minTempLabel.text = "최저 \(Int(data.value.0))°"
        maxTempLabel.text = "최고 \(Int(data.value.1))°"
    }
    
}
