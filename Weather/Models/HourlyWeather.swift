//
//  HourlyWeather.swift
//  Weather
//
//  Created by Yukeriia Suprun on 16.11.2022.
//

import Foundation

class HourlyWeather: Weather {
    private let temperature: Float
    
    init(time: String,
         windDirection: WindDirection,
         windSpeed: Float,
         weatherType: WeatherType,
         temperature: Float) {
        self.temperature = temperature
        super.init(time: time,
                   windDirection: windDirection,
                   windSpeed: windSpeed,
                   weatherType: weatherType)
    }
}
