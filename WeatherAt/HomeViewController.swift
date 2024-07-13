//
//  HomeViewController.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/10/24.
//

import UIKit
import SnapKit

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
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.2
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        
        view.delegate = self
        view.dataSource = self
        view.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.id)
        return view
    }()
    
    private lazy var forecastTableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.id)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mapButton = {
        let view = UIBarButtonItem(image: UIImage(systemName: "map")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: nil)
        return view
    }()
    
    private lazy var listButton = {
        let view = UIBarButtonItem(image: UIImage(systemName: "list.dash")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: nil)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    private func bindData() {
        viewModel.mainOutput.bind { result in
            guard let result else { return }
            self.cityLabel.text = result.cityname
            self.descriptionLabel.text = result.description
            self.tempLabel.text = result.tempLabel
            self.minmaxLabel.text = result.minmaxLabel
        }
        viewModel.outputForecast.bind { result in
            guard result != nil else { return }
            self.forecastCollectionView.reloadData()
            self.forecastTableView.reloadData()
        }
    }
    
    override func configureView() {
        super.configureView()
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
        contentView.addSubview(forecastCollectionView)
        contentView.addSubview(forecastTableView)
    }
    
    override func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        cityLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(32)
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
        
        forecastCollectionView.snp.makeConstraints {
            $0.top.equalTo(minmaxLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(safeArea).inset(16)
            $0.height.equalTo(100)
        }
        
        forecastTableView.snp.makeConstraints {
            $0.top.equalTo(forecastCollectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea).inset(16)
            $0.height.equalTo(360)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
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
