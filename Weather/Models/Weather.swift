//
//  Weather.swift
//  Weather
//
//  Created by Yukeriia Suprun on 16.11.2022.
//

import Foundation

class Weather {
    private(set) var id = UUID()
    let date: Date
    let windDirection: WindDirection
    let windSpeed: Float
    let weatherType: WeatherType
    let temperature: Float?
    let maxTemperature: Float?
    let minTemperature: Float?
    let humidity: Int?
    let weatherUnits: WeatherUnits
    
    init(date: Date,
         windDirection: WindDirection,
         windSpeed: Float,
         weatherType: WeatherType,
         temperature: Float? = nil,
         maxTemperature: Float? = nil,
         minTemperature: Float? = nil,
         humidity: Int? = nil,
         weatherUnits: WeatherUnits) {
        self.id = UUID()
        self.date = date
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.weatherType = weatherType
        self.temperature = temperature
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.humidity = humidity
        self.weatherUnits = weatherUnits
    }
    
}

extension Weather: Identifiable, Hashable, Comparable {
    static func < (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.date < rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
    
}
