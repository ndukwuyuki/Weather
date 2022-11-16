//
//  NetworkService.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import Foundation
import MapKit
import Alamofire
import SwiftyJSON

class NetworkService {
    static let shared = NetworkService()
    
    fileprivate init() { }
    
    func getDailyWeather(for cityName: String, forecastType: ForecastType = .all ) {
        GeolocationService.shared.getCoordinatesForCity(cityName) {[weak self] coordinate, timezone in
            guard let coordinate = coordinate,
                  let timezone = timezone,
                  let url = URL(string: OpenMeteoConstants.baseURL)
            else { return }
            
            var params : [String : Any] = [
                OpenMeteoConstants.ParametersName.latitude.rawValue : coordinate.latitude,
                OpenMeteoConstants.ParametersName.longitude.rawValue : coordinate.longitude,
                OpenMeteoConstants.ParametersName.timezone.rawValue : timezone.identifier
            ]
            
            switch forecastType {
            case .daily:
                self?.addDailyWeatherParams(&params)
            case .hourly:
                self?.addHourlyParams(&params)
            case .all:
                self?.addDailyWeatherParams(&params)
                self?.addHourlyParams(&params)
            }
            
            AF.request(url, method: .get, parameters: params).responseJSON { [weak self] response in
                self?.parceResponse(response)
            }
            
        }
    }
    
    private func addDailyWeatherParams(_ params: inout [String: Any]) {
        params[OpenMeteoConstants.ParametersName.daily.rawValue] = DailyWeatherParams.allCases.map { $0.rawValue }
    }
    
    private func addHourlyParams(_ params: inout [String: Any]) {
        params[OpenMeteoConstants.ParametersName.hourly.rawValue] = HourlyWeatherParams.allCases.map { $0.rawValue }
    }
    
    private func parceResponse(_ response: AFDataResponse<Any>) {
        let json = JSON(response.value as Any)
        let forecast = Forecast(json: json)
        print(forecast)
        
    }
    
    func test() {
        CLGeocoder().geocodeAddressString("London") { placemark, error in
            if let location = placemark?.first?.location {
                print(location.coordinate.latitude)
                print(location.coordinate.longitude)
            } else if let error = error {
                print(error)
            }
        }
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

enum ForecastType {
    case daily
    case hourly
    case all
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
    case latitude
    case longitude
    case time
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
