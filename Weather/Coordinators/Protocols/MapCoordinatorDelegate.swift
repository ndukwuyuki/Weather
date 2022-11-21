//
//  MapCoordinatorDelegate.swift
//  Weather
//
//  Created by Yukeriia Suprun on 21.11.2022.
//

import Foundation
import CoreLocation

protocol MapCoordinatorDelegate {
    func locationChanged(to coordinate: CLLocationCoordinate2D)
}
