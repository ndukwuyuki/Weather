//
//  SearchCityCoordinatorInput.swift
//  Weather
//
//  Created by Yukeriia Suprun on 20.11.2022.
//

import Foundation

protocol SearchCityCoordinatorInput {
    func didChangeCity(to city: CityViewModel)
    func back()
}
