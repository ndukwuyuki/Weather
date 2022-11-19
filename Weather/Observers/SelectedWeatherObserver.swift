//
//  SelectedWeatherObserver.swift
//  Weather
//
//  Created by Yukeriia Suprun on 18.11.2022.
//

import Foundation
import RxSwift

protocol SelectedWeatherObserverDelegate {
    func selectedWeatherChanged(to weatherViewModel: WeatherViewModel)
}

class SelectedWeatherObserver: ObserverType {
    var delegate: SelectedWeatherObserverDelegate?
    func on(_ event: RxSwift.Event<WeatherViewModel>) {
        switch event {
        case .next(let weatherViewModel):
            delegate?.selectedWeatherChanged(to: weatherViewModel)
        case .error(let error):
            print(error)
        case .completed:
            print("completed")
        }
        
    }
    
    typealias Element = WeatherViewModel
}
