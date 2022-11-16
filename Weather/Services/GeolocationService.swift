//
//  GeolocationService.swift
//  Weather
//
//  Created by Yukeriia Suprun on 16.11.2022.
//

import Foundation
import MapKit

class GeolocationService {
    static let shared = GeolocationService()
    
    fileprivate init() { }
    
    func getCoordinatesForCity(_ cityName: String, completionHandler: @escaping (CLLocationCoordinate2D?, TimeZone?) -> Void) {
        CLGeocoder().geocodeAddressString("London") { placemark, _ in
            completionHandler(placemark?.first?.location?.coordinate, placemark?.first?.timeZone)
        }
    }
}
