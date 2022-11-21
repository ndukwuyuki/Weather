//
//  SearchCityViewController.swift
//  Weather
//
//  Created by Yukeriia Suprun on 20.11.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchCityViewController: UIViewController {
    
    var coordinator: SearchCityCoordinatorInput?
    var viewModel: SearchCityViewModel?
    
    private let disposeBag = DisposeBag()
    private var citySearchBar = UISearchBar()
    private let resultsTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        // Do any additional setup after loading the view.
    }
    
    private func configureSubviews() {
        configureCityTextField()
        configureResultsTableView()
        configureNavigationBar()
        bindResultsTableView()
        bindCityTextField()
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = citySearchBar
    }
    
    private func configureCityTextField() {
        citySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: navigationController?.navigationBar.frame.width ?? 0, height: 40))
        citySearchBar.searchTextField.font = UIConstants.font
        citySearchBar.layer.cornerRadius = 3
        citySearchBar.layer.masksToBounds = true
    }
    
    private func configureResultsTableView() {
        resultsTableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityTableViewCell")
        resultsTableView.separatorStyle = .none
        view.addSubview(resultsTableView)
        
        resultsTableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
    }
    
    
    private func bindCityTextField() {
        guard let viewModel = viewModel else { return }
        citySearchBar.rx.text.map({ $0 ?? ""}).bind(to: viewModel.searchValue).disposed(by: disposeBag)
        
        viewModel.selectedCity.subscribe (onNext: { [weak self] viewModel in
            self?.coordinator?.didChangeCity(to: viewModel)
        }).disposed(by: disposeBag)
    }
    
    private func bindResultsTableView() {
        resultsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel?.filteredCities
            .bind(to: resultsTableView.rx.items(cellIdentifier: "CityTableViewCell", cellType: CityTableViewCell.self)) { (row, item, cell) in
                cell.cityName = item.cityName
            }.disposed(by: disposeBag)
        
        guard let viewModel = viewModel else { return }
        
        resultsTableView.rx.modelSelected(CityViewModel.self).bind(to: viewModel.selectedCity).disposed(by: disposeBag)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchCityViewController: UITableViewDelegate {
    
}

private struct UIConstants {
    static let font = UIFont(name: "CourierNewPSMT", size: 20) ?? UIFont.systemFont(ofSize: 20)
}
