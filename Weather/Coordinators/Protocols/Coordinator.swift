//
//  Coordinator.swift
//  Weather
//
//  Created by Yukeriia Suprun on 20.11.2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    
    func start()
}
