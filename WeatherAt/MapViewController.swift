//
//  MapViewController.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/14/24.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation

final class MapViewController: BaseViewController {
    
//    private let locationManager = CLLocationManager()
    private lazy var locationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    // 새싹좌표
    let center = CLLocationCoordinate2D(latitude: 37.517857, longitude: 126.886714)
    
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDeviceLocationAuthorization()
    }
    
    override func configureHierarchy() {
        view.addSubview(mapView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
  
}

extension MapViewController: CLLocationManagerDelegate {
    
    private func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization()
                }
            }
            else {
                self.showAlert(message: "위치 서비스가 켜져 있어야 합니다.", actionTitle: "확인")
            }
        }
    }
    
    private func checkCurrentLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            showAlert(message: "위치 사용 권한이 필요합니다.", actionTitle: "확인")
            configureMapView(center)
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lat = manager.location?.coordinate.latitude,
              let lon = manager.location?.coordinate.longitude else { return }
        locationManager.stopUpdatingLocation()
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        configureMapView(center)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
}

extension MapViewController {
    
    private func configureMapView(_ center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
}
