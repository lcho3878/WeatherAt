//
//  ViewController.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/10/24.
//

import UIKit

class BaseViewController: UIViewController, Base {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
    }

    func configureView() {
        view.backgroundColor = .darkGray
    }
    
    func configureHierarchy() {}
    
    func configureLayout() {}
    
}

