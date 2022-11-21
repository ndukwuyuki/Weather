//
//  GeolocationService.swift
//  Weather
//
//  Created by Yukeriia Suprun on 16.11.2022.
//

import Foundation
import LMGeocoder

class GeolocationService {
    static let shared = GeolocationService()
    
    fileprivate init() { }
    
    func getCoordinatesForCity(_ cityName: String, completion: @escaping (CLLocationCoordinate2D?, TimeZone?, City?) -> Void) {
        LMGeocoder.sharedInstance().geocodeAddressString(cityName,
                                                         service: LMGeocoderServiceGoogle, alternativeService: LMGeocoderServiceApple) { addresses, error in
            guard let address = addresses?.first else { return }
            completion(address.coordinate,
                       TimeZone.current,
                       City(country: address.country ?? "",
                            city: address.locality ?? ""))
        }
    }
    
    func getCityForCoordinates(_ coordinate: CLLocationCoordinate2D, completion: @escaping (CLLocationCoordinate2D?, TimeZone?, City?) -> Void) {
          LMGeocoder.sharedInstance().reverseGeocodeCoordinate(coordinate,
                                                             service: LMGeocoderServiceGoogle, alternativeService: LMGeocoderServiceApple) { addresses, error in
            guard let address = addresses?.first else { return }
            completion(address.coordinate,
                       TimeZone.current,
                       City(country: address.country ?? "",
                            city: address.locality ?? ""))
        }
    }
}
