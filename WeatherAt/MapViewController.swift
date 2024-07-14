//
//  MapViewController.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/14/24.
//

import UIKit
import MapKit
import SnapKit

final class MapViewController: BaseViewController {
    
    private let mapView = MKMapView()
    
    override func configureHierarchy() {
        view.addSubview(mapView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
  
}
