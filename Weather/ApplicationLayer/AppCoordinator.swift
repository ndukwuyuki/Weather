//
//  AppCoordinator.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = ViewControllersFactory.navigationController
        let weatherViewController = ViewControllersFactory.weatherViewController
        navigationController.setViewControllers([weatherViewController], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
