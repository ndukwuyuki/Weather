//
//  AppCoordinator.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import UIKit
import CoreLocation

class AppCoordinator: Coordinator, AppCoordinatorInput {
    
    private(set) var navigationController: UINavigationController
    private var viewModel = ForecastViewModel()
 
    private let window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController = ViewControllersFactory.navigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let weatherViewController = ViewControllersFactory.weatherViewController
        weatherViewController.coordinator = self
        weatherViewController.viewModel = viewModel
        weatherViewController.loadViewIfNeeded()
        navigationController.pushViewController(weatherViewController, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func didTapChangeCity() {
        let searchCityCoordinator = SearchCityCoordinator(navigationController: navigationController)
        searchCityCoordinator.delegate = self
        searchCityCoordinator.start()
    }
        
    func didTapChangeLocation() {
        let mapCoordinator = MapCoordinator(navigationController: navigationController)
        mapCoordinator.delegate = self
        mapCoordinator.start()
    }
    
}

extension AppCoordinator: SearchCityCoordinatorDelegate {
    func cityChanged(to city: String) {
        viewModel.fetchForecast(for: city)
    }
}

extension AppCoordinator: MapCoordinatorDelegate {
    func locationChanged(to coordinate: CLLocationCoordinate2D) {
        viewModel.fetchForecast(for: coordinate)
    }
}
