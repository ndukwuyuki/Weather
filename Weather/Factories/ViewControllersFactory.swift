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
        navigationController.navigationBar.backgroundColor = UIConstants.backgroundColor
        return navigationController
    }
    
    class var weatherViewController: WeatherViewController {
        let viewController = WeatherViewController()
        return viewController
    }
    
    class var searchCityViewController: SearchCityViewController {
        let viewController = SearchCityViewController()
        return viewController
    }
    
}

private struct UIConstants {
    static let backgroundColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
}


