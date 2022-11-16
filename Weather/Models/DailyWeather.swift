//
//  DailyWeather.swift
//  Weather
//
//  Created by Yukeriia Suprun on 16.11.2022.
//

import Foundation

class DailyWeather: Weather {
    private let maxTemperature: Float
    private let minTemperature: Float
    private let humidity: Int
    
    init(time: String,
         windDirection: WindDirection,
         windSpeed: Float,
         weatherType: WeatherType,
         humidity: Int,
         maxTemperature: Float,
         minTemperature: Float) {
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.humidity = humidity
        super.init(time: time,
                   windDirection: windDirection,
                   windSpeed: windSpeed,
                   weatherType: weatherType)
    }
    
}
