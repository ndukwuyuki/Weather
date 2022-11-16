//
//  Forecast.swift
//  Weather
//
//  Created by Yukeriia Suprun on 16.11.2022.
//

import Foundation
import SwiftyJSON
import CoreLocation

class Forecast {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    private(set) var dailyWeather: [DailyWeather] = []
    private(set) var hourlyWeather: [HourlyWeather] = []
    let dailyUnits: [String : String]
    let hourlyUnits: [String : String]
    
    init?(json: JSON) {
        guard let dictionary = json.dictionary,
              let latitude = dictionary[ResponseParams.latitude.rawValue]?.double,
              let longitude = dictionary[ResponseParams.longitude.rawValue]?.double,
              let dailyDictionary = dictionary[ResponseParams.daily.rawValue]?.dictionary,
              let hourlyDictionary = dictionary[ResponseParams.hourly.rawValue]?.dictionary,
              let humidityArray = hourlyDictionary[ResponseParams.relativeHumidity.rawValue]?.array?.map({ $0.intValue }),
              let dailyUnits = dictionary[ResponseParams.dailyUnits.rawValue]?.dictionary?.mapValues({ $0.stringValue }),
              let hourlyUnits = dictionary[ResponseParams.hourlyUnits.rawValue]?.dictionary?.mapValues({ $0.stringValue })
        else { return nil }
        self.latitude = CLLocationDegrees(floatLiteral: latitude)
        self.longitude = CLLocationDegrees(floatLiteral: longitude)
        self.dailyUnits = dailyUnits
        self.hourlyUnits = hourlyUnits
        
        dailyWeather = parseDailyWeather(dailyDictionary: dailyDictionary, humidityArray: humidityArray)
        hourlyWeather = parseHourlyWeather(hourlyDictionary: hourlyDictionary)
    }
    
    private func parseDailyWeather(dailyDictionary: [String : JSON], humidityArray: [Int]) -> [DailyWeather] {
        guard let dailyTimeArray = dailyDictionary[ResponseParams.time.rawValue]?.array?.map({ $0.stringValue }),
              let minTemperatureArray = dailyDictionary[ResponseParams.minTemperature.rawValue]?.array?.map({ $0.floatValue }),
              let maxTemperatureArray = dailyDictionary[ResponseParams.maxTemperature.rawValue]?.array?.map({ $0.floatValue }),
              let windSpeedArray = dailyDictionary[ResponseParams.maxWindSpeed.rawValue]?.array?.map({ $0.floatValue }),
              let windDirectionArray = dailyDictionary[ResponseParams.dominantWindDirection.rawValue]?.array?.map({ $0.floatValue }),
              let weathercodeArray = dailyDictionary[ResponseParams.weatherCode.rawValue]?.array?.map({ $0.intValue })
        else { return [] }
        
        var array: [DailyWeather] = []
        
        for index in 0 ..< dailyTimeArray.count {
            let startIndex = index * 24
            let endIndex = startIndex + 23
            guard let maxHumidity = humidityArray[startIndex ... endIndex].max()
            else { break }
            let windDirection = WindDirection.getWindDirectionBy(degrees: windDirectionArray[index])
            let weatherType = WeatherType.weatherTypeBy(weathercode: weathercodeArray[index])
            array.append(DailyWeather(time: dailyTimeArray[index], windDirection: windDirection, windSpeed: windSpeedArray[index], weatherType: weatherType, humidity: maxHumidity, maxTemperature: maxTemperatureArray[index], minTemperature: minTemperatureArray[index]))
        }
        return array
    }
    
    private func parseHourlyWeather(hourlyDictionary: [String: JSON]) -> [HourlyWeather] {
        guard let timeArray = hourlyDictionary[ResponseParams.time.rawValue]?.array?.map({ $0.stringValue }),
              let temperatureArray = hourlyDictionary[ResponseParams.temperature.rawValue]?.array?.map({ $0.floatValue }),
              let windDirectionArray = hourlyDictionary[ResponseParams.windDirection.rawValue]?.array?.map({ $0.floatValue }),
              let windSpeedArray = hourlyDictionary[ResponseParams.windSpeed.rawValue]?.array?.map({ $0.floatValue }),
              let weathercodeArray = hourlyDictionary[ResponseParams.weatherCode.rawValue]?.array?.map({ $0.intValue })
        else { return [] }
              
        var array: [HourlyWeather] = []
        
        for index in 0 ..< timeArray.count {
            let windDirection = WindDirection.getWindDirectionBy(degrees: windDirectionArray[index])
            let weatherType = WeatherType.weatherTypeBy(weathercode: weathercodeArray[index])
            array.append(HourlyWeather(time: timeArray[index],
                                       windDirection: windDirection,
                                       windSpeed: windSpeedArray[index],
                                       weatherType: weatherType,
                                       temperature: temperatureArray[index]))
        }
        
        return array
    }
    
}
