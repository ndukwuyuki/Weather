//
//  MapCoordinatorInput.swift
//  Weather
//
//  Created by Yukeriia Suprun on 21.11.2022.
//

import Foundation
import CoreLocation

protocol MapCoordinatorInput {
    func didChangeLocation(to coordinate: CLLocationCoordinate2D)
    func back()
}
