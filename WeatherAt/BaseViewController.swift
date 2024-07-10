//
//  ViewController.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/10/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarhcy()
        configureLayout()
    }

    func configureView() {
        view.backgroundColor = .darkGray
    }
    
    func configureHierarhcy() {}
    
    func configureLayout() {}
    
}

