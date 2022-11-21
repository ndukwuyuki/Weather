//
//  CityViewModel.swift
//  Weather
//
//  Created by Yukeriia Suprun on 20.11.2022.
//

import Foundation


struct CityViewModel {
    var cityName: String {
        return city.city.capitalized + ", " + city.country.capitalized
    }
    
    private let city: City
    
    init(city: City) {
        self.city = city
    }
}
