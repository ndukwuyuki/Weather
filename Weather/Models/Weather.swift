//
//  Weather.swift
//  Weather
//
//  Created by Yukeriia Suprun on 16.11.2022.
//

import Foundation

class Weather {
    private(set) var id = UUID()
    private let time: String
    private let windDirection: WindDirection
    private let windSpeed: Float
    private let weatherType: WeatherType
    private let temperature: Float?
    private let maxTemperature: Float?
    private let minTemperature: Float?
    private let humidity: Int?
    
    init(time: String,
         windDirection: WindDirection,
         windSpeed: Float,
         weatherType: WeatherType,
         temperature: Float? = nil,
         maxTemperature: Float? = nil,
         minTemperature: Float? = nil,
         humidity: Int? = nil) {
        self.id = UUID()
        self.time = time
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.weatherType = weatherType
        self.temperature = temperature
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.humidity = humidity
    }
}

extension Weather: Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
    
}
