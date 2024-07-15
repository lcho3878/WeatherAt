//
//  HomeViewController.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/10/24.
//

import UIKit
import SnapKit
import MapKit

final class HomeViewController: BaseViewController {
    
    private let viewModel = HomeViewModel()
    
    private let scrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let contentView = UIView()
    
    private let cityLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 40)
        return view
    }()
    
    private let tempLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 96, weight: .thin)
        return view
    }()
    
    private let descriptionLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 24)
        return view
    }()
    
    private let minmaxLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 24)
        return view
    }()

    private lazy var forecastCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let n: CGFloat = 5
        let spacing: CGFloat = 0
        layout.minimumLineSpacing = spacing
        let width = (UIScreen.main.bounds.width - (n - 1) * spacing - 32)
        layout.itemSize = CGSize(width: width / n, height: 100)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        
        view.delegate = self
        view.dataSource = self
        view.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.id)
        return view
    }()
    
    private lazy var collectionViewBackground = TranslucentView(title: "3시간 간격의 일기예보", image: UIImage(systemName: "calendar"), contentView: forecastCollectionView, color: .label)
    
    private lazy var forecastTableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.id)
        view.backgroundColor = .clear
        view.separatorColor = .lightGray
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var tableViewBackground = TranslucentView(title: "5일 간의 일기예보", image: UIImage(systemName: "calendar"), contentView: forecastTableView, color: .label)
    
    private let mapView = {
        let view = MKMapView()
        return view
    }()
    
    private lazy var mapViewBackground = TranslucentView(title: "위치", image: UIImage(systemName: "thermometer.medium"), contentView: mapView, color: .label)
    
    private let windView = TranslucentView(title: "바람 속도", image: UIImage(systemName: "wind"), color: .lightGray)
    
    private let windLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 30)
        return view
    }()
    
    private let cloudView = TranslucentView(title: "구름", image: UIImage(systemName: "cloud.fill"), color: .lightGray)
    
    private let cloudLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 30)
        return view
    }()
    
    private let atmoshpereView = TranslucentView(title: "기압", image: UIImage(systemName: "thermometer.medium"), color: .lightGray)
    
    private let atmoshpereLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 30)
        return view
    }()
    
    private let humidityView = TranslucentView(title: "습도", image: UIImage(systemName: "humidity"), color: .lightGray)
    
    private let humidityLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 30)
        return view
    }()
    
    private lazy var mapButton = {
        let view = UIBarButtonItem(image: UIImage(systemName: "map")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(mapButtonClicked))
        return view
    }()
    
    private lazy var listButton = {
        let view = UIBarButtonItem(image: UIImage(systemName: "list.dash")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(listButtonClicked))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    private func bindData() {
        
        viewModel.outputWeather.bind { result in
            guard let result else { return }
            self.cityLabel.text = result.name
            self.descriptionLabel.text = result.weather.first?.description
            self.tempLabel.text = "\(result.main.temp.roundUp(demical: 1))°"
            self.minmaxLabel.text = "최고 : \(result.main.tempMax.roundUp(demical: 1))° | 최저 : \(result.main.tempMin.roundUp(demical: 1))°"
            self.windLabel.text = "\(result.wind.speed.roundUp(demical: 2))m/s"
            self.cloudLabel.text = "\(result.clouds.all)%"
            self.atmoshpereLabel.text = "\(result.main.pressure.formatted())hpa"
            self.humidityLabel.text = "\(result.main.humidity)%"
            
            let center = CLLocationCoordinate2D(latitude: result.coord.lat, longitude: result.coord.lon)
            self.configureMapView(center, cityname: result.name)
            
        }
        
        viewModel.outputForecast.bind { result in
            guard result != nil else { return }
            self.forecastCollectionView.reloadData()
            self.forecastTableView.reloadData()
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .label
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [mapButton, space ,listButton]
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cityLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(minmaxLabel)
        contentView.addSubview(collectionViewBackground)
        contentView.addSubview(tableViewBackground)
        contentView.addSubview(mapViewBackground)
        contentView.addSubview(windView)
        windView.contentView.addSubview(windLabel)
        contentView.addSubview(cloudView)
        cloudView.contentView.addSubview(cloudLabel)
        contentView.addSubview(atmoshpereView)
        atmoshpereView.contentView.addSubview(atmoshpereLabel)
        contentView.addSubview(humidityView)
        humidityView.contentView.addSubview(humidityLabel)
    }
    
    override func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(safeArea)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        cityLabel.snp.makeConstraints {
            $0.top.equalTo(contentView)
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
        
        collectionViewBackground.snp.makeConstraints {
            $0.top.equalTo(minmaxLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(safeArea).inset(16)
            $0.height.equalTo(140)
        }
        
        tableViewBackground.snp.makeConstraints {
            $0.top.equalTo(collectionViewBackground.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea).inset(16)
            $0.height.equalTo(400)
        }
        
        mapViewBackground.snp.makeConstraints {
            $0.top.equalTo(tableViewBackground.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea).inset(16)
            $0.height.equalTo(200)
        }
        
        windView.snp.makeConstraints {
            $0.top.equalTo(mapViewBackground.snp.bottom).offset(8)
            $0.leading.equalTo(mapViewBackground)
            $0.trailing.equalTo(contentView.snp.centerX).inset(4)
            $0.height.equalTo(windView.snp.width)
        }
        
        windLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        cloudView.snp.makeConstraints {
            $0.top.size.bottom.equalTo(windView)
            $0.leading.equalTo(contentView.snp.centerX).offset(4)
            $0.bottom.equalTo(windView)
        }
        
        cloudLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        atmoshpereView.snp.makeConstraints {
            $0.top.equalTo(windView.snp.bottom).offset(8)
            $0.size.centerX.equalTo(windView)
            $0.bottom.equalTo(contentView.snp.bottom).inset(40)
        }
        
        atmoshpereLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        humidityView.snp.makeConstraints {
            $0.top.size.bottom.equalTo(atmoshpereView)
            $0.centerX.equalTo(cloudView)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
    }
    
}

extension HomeViewController {
    @objc
    private func listButtonClicked() {
        let searchVC = SearchViewController()
        searchVC.closure = { id in
            self.viewModel.requestInput.value = id
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc
    private func mapButtonClicked() {
        let mapVC = MapViewController()
        mapVC.closure = { coord in
            let lat = coord.latitude
            let lon = coord.longitude
            self.viewModel.mapViewInput.value = [lat, lon]
        }
        navigationController?.pushViewController(mapVC, animated: true)
    }
}

extension HomeViewController {
    private func configureMapView(_ center: CLLocationCoordinate2D, cityname: String) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.region = MKCoordinateRegion(center: center, latitudinalMeters: 100000, longitudinalMeters: 100000)
        let annotation = MKPointAnnotation()
        annotation.title = cityname
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputForecast.value?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.id, for: indexPath) as? ForecastCollectionViewCell else { return UICollectionViewCell() }
        if let data = viewModel.outputForecast.value?.list[indexPath.item] {
            cell.configureData(data)
        }
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputForecast.value?.dailyList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.id, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
        if let data = viewModel.outputForecast.value?.dailyList[indexPath.row] {
            cell.configureData(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
