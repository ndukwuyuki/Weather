//
//  WindDirection.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import Foundation

enum WindDirection: String, Codable {
    case north
    case south
    case east
    case west
    case northeast
    case northwest
    case southeast
    case southwest
    
    var description: String {
        return "\(rawValue) wind"
    }
    
    static func getWindDirectionBy(degrees: Float) -> WindDirection {
        switch degrees {
        case 348.75...360:
            return .north
        case 0...11.25:
            return .north
        case 11.25...78.75:
            return northeast
        case 78.75...101.25:
            return .east
        case 101.25...168.75:
            return .southeast
        case 168.75...191.25:
            return .south
        case 191.25...258.75:
            return southwest
        case 258.75...281.25:
            return .west
        case 281.25...348.75:
            return .northwest
        default:
            return .north
        }
    }
    
}
