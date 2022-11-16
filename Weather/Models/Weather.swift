//
//  Weather.swift
//  Weather
//
//  Created by Yukeriia Suprun on 16.11.2022.
//

import Foundation

class Weather {
    private let time: String
    private let windDirection: WindDirection
    private let windSpeed: Float
    private let weatherType: WeatherType
    
    init(time: String,
         windDirection: WindDirection,
         windSpeed: Float,
         weatherType: WeatherType) {
        self.time = time
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.weatherType = weatherType
    }
}

extension Weather {
    enum CodingKeys: String, CodingKey {
        case time
        case windDirection
        case windSpeed
        case weatherType
    }
}
