//
//  CityNameObserver.swift
//  Weather
//
//  Created by Yukeriia Suprun on 18.11.2022.
//

import Foundation
import RxSwift

protocol CityNameObserverDelegate {
    func cityNameChanged(to cityName: String)
}

class CityNameObserver: ObserverType {
    var delegate: CityNameObserverDelegate?
    
    func on(_ event: RxSwift.Event<String>) {
        switch event {
        case .next(let cityName):
            delegate?.cityNameChanged(to: cityName)
        case .error(let error):
            print(error)
        case .completed:
            print("completed")
        }
    }
    
    typealias Element = String
}
