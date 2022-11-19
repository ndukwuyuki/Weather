//
//  ImageFactory.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import UIKit

class ImageFactory {
    
    fileprivate init() { }
    
    class var backImage: UIImage? {
        return UIImage(named: ImageNames.back.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
    
    class var humidityImage: UIImage? {
        return UIImage(named: ImageNames.humidity.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
    
    class var locationImage: UIImage? {
        return UIImage(named: ImageNames.location.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
    
    class var markerImage: UIImage? {
        return UIImage(named: ImageNames.marker.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
    
    class var searchImage: UIImage? {
        return UIImage(named: ImageNames.search.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
    
    class var temperatureImage: UIImage? {
        return UIImage(named: ImageNames.temperature.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
    
    class var windImage: UIImage? {
        return UIImage(named: ImageNames.wind.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
    
    class func weatherImage(for weather: WeatherType) -> UIImage? {
        return UIImage(named: weather.description)?.withRenderingMode(.alwaysTemplate)
    }
    
    class func windDirectionImage(for direction: WindDirection) -> UIImage? {
        return UIImage(named: direction.description)?.withRenderingMode(.alwaysTemplate)
    }
    
}

private enum ImageNames: String {
    case back
    case humidity
    case location
    case marker
    case search
    case temperature
    case wind
}
