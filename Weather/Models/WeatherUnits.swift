//
//  WeatherUnits.swift
//  Weather
//
//  Created by Yukeriia Suprun on 17.11.2022.
//

import Foundation

class WeatherUnits {
    let maxTemperatureUnit: String
    let minTemperatureUnit: String
    let temperatureUnit: String
    let windSpeedUnit: String
    let windDirectionUnit: String
    let dominantWindDirectionUnit: String
    let maxWindSpeedUnit: String
    let humidityUnit = "%"
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        maxTemperatureUnit = try values.decode(String.self,
                                               forKey: .maxTemperature)
        minTemperatureUnit = try values.decode(String.self,
                                               forKey: .minTemperature)
        temperatureUnit = try values.decode(String.self,
                                            forKey: .temperature)
        windSpeedUnit = try values.decode(String.self,
                                          forKey: .windSpeed)
        windDirectionUnit = try values.decode(String.self,
                                              forKey: .windDirection)
        dominantWindDirectionUnit = try values.decode(String.self,
                                                      forKey: .dominantWindDirection)
        maxWindSpeedUnit = try values.decode(String.self,
                                             forKey: .maxWindSpeed)
    }
}

extension WeatherUnits: Decodable {
    enum CodingKeys: String, CodingKey {
        case minTemperature = "temperature_2m_min"
        case maxTemperature = "temperature_2m_max"
        case temperature = "temperature_2m"
        case dominantWindDirection = "winddirection_10m_dominant"
        case windDirection = "winddirection_10m"
        case maxWindSpeed = "windspeed_10m_max"
        case windSpeed = "windspeed_10m"
    }
}
