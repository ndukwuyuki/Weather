//
//  MapCoordinator.swift
//  Weather
//
//  Created by Yukeriia Suprun on 21.11.2022.
//

import Foundation
import UIKit
import CoreLocation

class MapCoordinator: Coordinator, MapCoordinatorInput {
    
    var delegate: MapCoordinatorDelegate?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mapViewController = ViewControllersFactory.mapViewController
        mapViewController.coordinator = self
        mapViewController.viewModel = MapViewModel()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
    func didChangeLocation(to coordinate: CLLocationCoordinate2D) {
        delegate?.locationChanged(to: coordinate)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.popViewController(animated: true)
    }
    
    func back() {
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.popViewController(animated: true)
    }
    
}
