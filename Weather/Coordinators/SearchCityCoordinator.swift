//
//  ChangeCityCoordinator.swift
//  Weather
//
//  Created by Yukeriia Suprun on 20.11.2022.
//

import UIKit

class SearchCityCoordinator: Coordinator, SearchCityCoordinatorInput {
    private(set) var navigationController: UINavigationController
    
    var delegate: SearchCityCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ViewControllersFactory.searchCityViewController
        viewController.coordinator = self
        viewController.viewModel = SearchCityViewModel()
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(false, animated: false)
    }
    
    func didChangeCity(to city: CityViewModel) {
        delegate?.cityChanged(to: city.cityName)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.popViewController(animated: true)
    }
    
    func back() {
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.popViewController(animated: true)
    }
    
}
