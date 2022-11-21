//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Yukeriia Suprun on 17.11.2022.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class ForecastViewModel {
    
    let city = PublishSubject<CityViewModel>()
    let dailyWeather = BehaviorSubject(value: [WeatherViewModel]())
    let hourlyWeather = BehaviorSubject(value: [WeatherViewModel]())
    let selectedWeather = PublishSubject<WeatherViewModel>()
    var selectedWeatherDriver: Driver<WeatherViewModel> {
        return selectedWeather.asDriver { _ in return .empty()}
    }
    
    private var forecast: Forecast?
    private let disposeBag = DisposeBag()
    
    init() {
        selectedWeatherDriver.drive (onNext: { [weak self] viewModel in
            guard let hourlyWeatherArray = self?.forecast?.weather.filter({ $0.key.id == viewModel.id }).first?.value
            else {
                self?.hourlyWeather.on(.error(NSError()))
                return
            }
            let hourlyWeatherViewModels = hourlyWeatherArray.map { WeatherViewModel(weather: $0) }
            self?.hourlyWeather.on(.next(hourlyWeatherViewModels))
        }).disposed(by: disposeBag)
    }
    
    func fetchForecast(for city: String) {
        fetchForecast(for: .cityName(city))
    }
    
    func fetchForecast(for coordinate: CLLocationCoordinate2D) {
        fetchForecast(for: .coordinate(coordinate))
    }
    
    private func fetchForecast(for location: Location) {
        NetworkService.shared.getForecast(for: location) { [weak self] city, forecast, error in
            if let city = city {
                self?.city.onNext(CityViewModel(city: city))
            }
            
            guard let forecast = forecast
            else {
                self?.dailyWeather.on(.error(error ?? NSError()))
                self?.hourlyWeather.on(.error(error ?? NSError()))
                self?.selectedWeather.on(.error(error ?? NSError()))
                return
            }
            
            self?.forecast = forecast
            let weather = forecast.weather.sorted(by: { $0.key < $1.key})
            let dailyWeather = forecast.weather.keys.sorted().map({ WeatherViewModel(weather: $0) })
            let hourlyWeather = weather.first?.value.sorted().map({ WeatherViewModel(weather: $0) }) ?? []
            self?.dailyWeather.on(.next(dailyWeather))
            self?.hourlyWeather.on(.next(hourlyWeather))
            if let selectedWeather = weather.first?.key {
                self?.selectedWeather.on(.next(WeatherViewModel(weather: selectedWeather)))
            } else {
                self?.selectedWeather.on(.error(NSError()))
            }
            
        }
    }
}
