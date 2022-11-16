//
//  ViewControllersFactory.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import UIKit

class ViewControllersFactory {
    
    fileprivate init() { }
    
    class var navigationController: UINavigationController {
        let navigationController = UINavigationController()
        return navigationController
    }
    
    class var weatherViewController: WeatherViewController {
        let viewController = WeatherViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }
}
