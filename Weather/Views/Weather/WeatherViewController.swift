//
//  WeatherViewController.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WeatherViewController: UIViewController {
    var coordinator: AppCoordinatorInput?
    var viewModel: ForecastViewModel?
    
    private let selectedWeatherObserver = SelectedWeatherObserver()
    private let cityNameObserver = CityNameObserver()

    private var dailyWeatherTableView: UITableView?
    private var hourlyWeatherCollectionView: UICollectionView?
    private var selectedWeatherView: SelectedWeatherView?
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        viewModel?.fetchForecast(for: "London")
    }
    
    private func configureSubviews() {
        configureSelectedWeatherView()
        configureHourlyWeatherCollectionView()
        configureDailyWeatherTableView()
        bindSelectedWeather()
        bindHourlyWeatherCollectionView()
        bindDailyWeatherTableView()
    }
    
    private func configureSelectedWeatherView() {
        selectedWeatherView = SelectedWeatherView(frame: view.frame)
        selectedWeatherView?.translatesAutoresizingMaskIntoConstraints = false
        selectedWeatherView?.backgroundColor = UIConstants.selectedWeatherBackgroundColor
        selectedWeatherView?.delegate = self
        guard let selectedWeatherView = selectedWeatherView else { return }
        
        view.addSubview(selectedWeatherView)
        selectedWeatherView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureHourlyWeatherCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        hourlyWeatherCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        hourlyWeatherCollectionView?.backgroundColor = UIConstants.hourlyWeatherBackgroundColor
        hourlyWeatherCollectionView?.allowsSelection = false
        hourlyWeatherCollectionView?.showsHorizontalScrollIndicator = false
        hourlyWeatherCollectionView?.register(HourlyWeatherCollectionViewCell.self,
                                              forCellWithReuseIdentifier: "HourlyWeatherCollectionViewCell")
        hourlyWeatherCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        guard let hourlyWeatherCollectionView = hourlyWeatherCollectionView else { return }
        
        view.addSubview(hourlyWeatherCollectionView)
        hourlyWeatherCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(selectedWeatherView?.snp.bottom ?? view.snp.top)
            make.height.equalTo(170)
        }
    }
    
    private func configureDailyWeatherTableView() {
        dailyWeatherTableView = UITableView(frame: view.frame)
        dailyWeatherTableView?.translatesAutoresizingMaskIntoConstraints = false
        dailyWeatherTableView?.register(DailyWeatherTableViewCell.self,
                                       forCellReuseIdentifier: "DailyWeatherTableViewCell")
        dailyWeatherTableView?.separatorStyle = .none
        dailyWeatherTableView?.rowHeight = UITableView.automaticDimension
        
        guard let dailyWeatherTableView = dailyWeatherTableView else { return }
        
        view.addSubview(dailyWeatherTableView)
        dailyWeatherTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(hourlyWeatherCollectionView?.snp.bottom ?? view.snp.top)
        }
    }
    
    private func bindSelectedWeather() {
        cityNameObserver.delegate = self
        selectedWeatherObserver.delegate = self
        viewModel?.city.subscribe(cityNameObserver).disposed(by: disposeBag)
        viewModel?.selectedWeather.subscribe(selectedWeatherObserver).disposed(by: disposeBag)
    }
    
    private func bindHourlyWeatherCollectionView() {
        
        guard let hourlyWeatherCollectionView = hourlyWeatherCollectionView else { return }
        hourlyWeatherCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel?.hourlyWeather.bind(to: hourlyWeatherCollectionView.rx.items(cellIdentifier: "HourlyWeatherCollectionViewCell", cellType: HourlyWeatherCollectionViewCell.self)) { (row, item, cell) in
            cell.time = item.time
            cell.weatherImage = item.weatherType
            cell.temperature = item.temperature
        }.disposed(by: disposeBag)
    }
    
    private func bindDailyWeatherTableView() {
        guard let dailyWeatherTableView = dailyWeatherTableView else { return }
        dailyWeatherTableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel?.dailyWeather.bind(to: dailyWeatherTableView.rx.items(cellIdentifier: "DailyWeatherTableViewCell", cellType: UITableViewCell.self)) { (row, viewModel,cell ) in
            guard let cell = cell as? DailyWeatherTableViewCell else { return }
            cell.isTopCell = row == 0
            cell.weekday = viewModel.weekday
            cell.temperature = viewModel.temperature
            cell.weatherImage = viewModel.weatherType
        }.disposed(by: disposeBag)
        
        guard let viewModel = viewModel else { return }
        dailyWeatherTableView.rx.modelSelected(WeatherViewModel.self).bind(to: viewModel.selectedWeather).disposed(by: disposeBag)
        
    }
    

}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.zPosition = CGFloat(tableView.numberOfRows(inSection: 0) - indexPath.row)
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if indexPath.row == 0 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
}

extension WeatherViewController: UICollectionViewDelegate {
    
}

extension WeatherViewController: SelectedWeatherViewDelegate {
    func didTapOnCity() {
        coordinator?.didTapChangeCity()
    }
    
    func didTapOnLocation() {
        coordinator?.didTapChangeLocation()
    }
    
}

extension WeatherViewController: SelectedWeatherObserverDelegate, CityNameObserverDelegate {
    func cityNameChanged(to cityName: String) {
        selectedWeatherView?.cityName = cityName
    }
    
    func selectedWeatherChanged(to weatherViewModel: WeatherViewModel) {
        selectedWeatherView?.dateString = weatherViewModel.day
        selectedWeatherView?.weatherImage = weatherViewModel.weatherType
        selectedWeatherView?.temperatureString = weatherViewModel.temperature
        selectedWeatherView?.humidityString = weatherViewModel.humidity
        selectedWeatherView?.windSpeedString = weatherViewModel.windSpeed
        selectedWeatherView?.windDirectionImage = weatherViewModel.windDirection
    }
}

private struct UIConstants {
    static let selectedWeatherBackgroundColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
    static let hourlyWeatherBackgroundColor = UIColor(red: 90.0/255.0, green: 159.0/255.0, blue: 240.0/255.0, alpha: 1.0)
}

