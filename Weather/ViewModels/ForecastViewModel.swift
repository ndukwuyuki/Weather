//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Yukeriia Suprun on 17.11.2022.
//

import Foundation
import RxSwift

final class ForecastViewModel {
    
    let city = PublishSubject<String>()
    let dailyWeather = BehaviorSubject(value: [WeatherViewModel]())
    let hourlyWeather = BehaviorSubject(value: [WeatherViewModel]())
    let selectedWeather = PublishSubject<WeatherViewModel>()
    
    private var forecast: Forecast?
    
    func fetchForecast(for city: String) {
        self.city.on(.next(city))
        NetworkService.shared.getDailyWeather(for: city) { [weak self] forecast, error in
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
    
    func setSelectedWeather(selectedWeather: WeatherViewModel) {
        self.selectedWeather.on(.next(selectedWeather))
        guard let hourlyWeatherArray = forecast?.weather.filter({ $0.key.id == selectedWeather.id }).first?.value
        else {
            hourlyWeather.on(.error(NSError()))
            return
        }
        let hourlyWeatherViewModels = hourlyWeatherArray.map { WeatherViewModel(weather: $0) }
        hourlyWeather.on(.next(hourlyWeatherViewModels))
    }
    
}
