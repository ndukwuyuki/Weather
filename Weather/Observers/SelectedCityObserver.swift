//
//  SelectedCityObserver.swift
//  Weather
//
//  Created by Yukeriia Suprun on 20.11.2022.
//

import Foundation
import RxSwift

protocol SelectedCityObserverDelegate {
    func didSelectCity(_ cityViewModel: CityViewModel)
}

class SelectedCityObserver: ObserverType {
    var delegate: SelectedCityObserverDelegate?
    
    func on(_ event: RxSwift.Event<CityViewModel>) {
        switch event {
        case .next(let model):
            delegate?.didSelectCity(model)
        case .completed:
            print("completed")
        case .error(let error):
            print(error)
        }
    }
    
    typealias Element = CityViewModel
}
