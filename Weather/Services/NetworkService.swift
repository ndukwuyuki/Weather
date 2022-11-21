//
//  NetworkService.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

class NetworkService {
    static let shared = NetworkService()
    
    fileprivate init() { }
    
    func getDailyWeather(for cityName: String,
                         completionHandler: @escaping (City?, Forecast?, Error?) -> Void) {
        GeolocationService.shared.getCoordinatesForCity(cityName) {[weak self] coordinate, timezone, city in
            guard let coordinate = coordinate,
                  let timezone = timezone,
                  let url = URL(string: OpenMeteoConstants.baseURL)
            else { return }
            
            var params : [String : Any] = [
                OpenMeteoConstants.ParametersName.latitude.rawValue : coordinate.latitude,
                OpenMeteoConstants.ParametersName.longitude.rawValue : coordinate.longitude,
                OpenMeteoConstants.ParametersName.timezone.rawValue : timezone.identifier
            ]
            
            self?.addWeatherParams(&params)
            
            AF.request(url, method: .get, parameters: params).responseJSON { response in
                let json = JSON(response.value as Any)
                
                do {
                    let forecast = try Forecast(json: json)
                    completionHandler(city, forecast, nil)
                } catch {
                    completionHandler(city, nil, error)
                }
            }
            
        }
    }
    
    private func addWeatherParams(_ params: inout [String: Any]) {
        params[OpenMeteoConstants.ParametersName.daily.rawValue] = DailyWeatherParams.allCases.map { $0.rawValue }
        params[OpenMeteoConstants.ParametersName.hourly.rawValue] = HourlyWeatherParams.allCases.map { $0.rawValue }
    }
}

private struct OpenMeteoConstants {
    static let baseURL = "https://api.open-meteo.com/v1/forecast"
    
    enum ParametersName: String {
        case latitude
        case longitude
        case daily
        case hourly
        case timezone
    }
}

enum HourlyWeatherParams: String, CaseIterable {
    case temperature = "temperature_2m"
    case relativeHumidity = "relativehumidity_2m"
    case windSpeed = "windspeed_10m"
    case windDirection = "winddirection_10m"
    case weatherCode = "weathercode"
}

enum DailyWeatherParams: String, CaseIterable {
    case maxTemperature = "temperature_2m_max"
    case minTemperature = "temperature_2m_min"
    case windSpeed = "windspeed_10m_max"
    case windDirection = "winddirection_10m_dominant"
    case weatherCode = "weathercode"
}

enum ResponseParams: String {
    case timezone = "timezone_abbreviation"
    case latitude
    case longitude
    case date = "time"
    case daily
    case dailyUnits = "daily_units"
    case hourly
    case hourlyUnits = "hourly_units"
    case temperature = "temperature_2m"
    case maxTemperature = "temperature_2m_max"
    case minTemperature = "temperature_2m_min"
    case relativeHumidity = "relativehumidity_2m"
    case weatherCode = "weathercode"
    case windSpeed = "windspeed_10m"
    case windDirection = "winddirection_10m"
    case maxWindSpeed = "windspeed_10m_max"
    case dominantWindDirection = "winddirection_10m_dominant"
}
