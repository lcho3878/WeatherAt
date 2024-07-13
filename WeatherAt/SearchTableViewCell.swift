//
//  SearchTableViewCell.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/14/24.
//

import UIKit
import SnapKit

final class SearchTableViewCell: BaseTableViewCell {
    
    private let tagLabel = {
        let view = UILabel()
        view.text = "#"
        return view
    }()
    
    private let nameLabel = {
        let view = UILabel()
        return view
    }()
    
    private let countryLabel = {
        let view = UILabel()
        view.text = "KR"
        return view
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(tagLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countryLabel)
    }
    
    override func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(4)
            $0.leading.equalTo(safeArea).offset(8)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel)
            $0.leading.equalTo(tagLabel.snp.trailing).offset(8)
        }
        
        countryLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalTo(safeArea).inset(8)
        }
        
    }
    
    func configureData(_ data: SearchViewModel.City) {
        nameLabel.text = data.name
        countryLabel.text = data.country
    }
    
}
