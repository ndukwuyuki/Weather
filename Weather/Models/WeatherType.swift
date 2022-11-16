//
//  Weather.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import Foundation

enum WeatherType: String, Codable {
    case bright
    case cloudy
    case rain
    case shower
    case thunder
    case snow
    case fog
    
    var description: String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return "\(rawValue) \((hour > 18 || hour < 6) ? "night" : "day")"
    }
    
    static func weatherTypeBy(weathercode: Int) -> WeatherType {
        switch weathercode {
        case 0: return .bright
        case 1, 2, 3: return .cloudy
        case 45, 48, 51, 53, 55, 56, 57: return .fog
        case 61, 63, 65, 66, 67: return .rain
        case 71, 73, 75, 77, 85, 86: return .snow
        case 80, 81, 82: return .shower
        case 95, 96, 99: return .thunder
        default: return .bright
        }
    }
}
