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
    
    func getCoordinatesForCity(_ cityName: String, completionHandler: @escaping (CLLocationCoordinate2D?, TimeZone?, City?) -> Void) {
        CLGeocoder().geocodeAddressString(cityName) { placemark, _ in
            completionHandler(placemark?.first?.location?.coordinate, placemark?.first?.timeZone, City(country: placemark?.first?.country ?? "", city: placemark?.first?.locality ?? ""))
        }
    }
}
