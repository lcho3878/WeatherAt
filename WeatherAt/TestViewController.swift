//
//  TestViewController.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/10/24.
//

import UIKit
import SnapKit

final class TestViewController: BaseViewController {
    
    private let cityLabel = {
        let view = UILabel()
        view.text = "Jeju City"
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 40)
        return view
    }()
    
    private let tempLabel = {
        let view = UILabel()
        view.text = "5.9°"
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 96, weight: .thin)
        return view
    }()
    
    private let descriptionLabel = {
        let view = UILabel()
        view.text = "Broken Clouds"
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 24)
        return view
    }()
    
    private let minmaxLabel = {
        let view = UILabel()
        view.text = "최고 : 7.0° | 최저 : -4.2°"
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 24)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    func configureHierarhcy() {
        view.addSubview(cityLabel)
        view.addSubview(tempLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(minmaxLabel)
    }
    
    override func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        cityLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(32)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(40)
        }
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(96)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(24)
        }
        
        minmaxLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(24)
        }
    }
}
