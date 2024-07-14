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
    
    func showAlert(title: String? = nil, message: String? = nil, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showAlert(title: String? = nil, message: String? = nil, hander: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            hander()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

