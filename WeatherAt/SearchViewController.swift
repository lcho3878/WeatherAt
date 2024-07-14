//
//  SearchViewController.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/14/24.
//

import UIKit
import SnapKit

final class SearchViewController: BaseViewController {
    
    private let viewModel = SearchViewModel()
    
    var closure: ((Int) -> Void)?
    
    private lazy var searchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "Search for a city."
        view.searchResultsUpdater = self
        return view
    }()
    
    private lazy var cityTableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    private func bindData() {
        viewModel.viewDidloadOutput.bind { _ in
            self.cityTableView.reloadData()
        }

        viewModel.cellSelectedOutput.bind { id in
            guard let id else { return }
            UserDefaults.standard.set(id, forKey: "cityID")
            self.closure?(id)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func configureView() {
        super.configureView()
        title = "City"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func configureHierarchy() {
        view.addSubview(cityTableView)
    }
    
    override func configureLayout() {
        cityTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewDidloadOutput.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        if let data = viewModel.viewDidloadOutput.value?[indexPath.row] {
            cell.configureData(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.viewDidloadOutput.value?[indexPath.row]
        viewModel.cellSelectedInput.value = data
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.searchTextInput.value = text
    }
    
}
