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
    private(set) var weather: [Weather: [Weather]] = [:]
    let weatherUnits: WeatherUnits
    
    init?(json: JSON) throws {
        guard let dictionary = json.dictionary,
              let timezoneIdentifier = dictionary[ResponseParams.timezone.rawValue]?.stringValue,
              let latitude = dictionary[ResponseParams.latitude.rawValue]?.double,
              let longitude = dictionary[ResponseParams.longitude.rawValue]?.double,
              let dailyDictionary = dictionary[ResponseParams.daily.rawValue]?.dictionary,
              let hourlyDictionary = dictionary[ResponseParams.hourly.rawValue]?.dictionary,
              let humidityArray = hourlyDictionary[ResponseParams.relativeHumidity.rawValue]?.array?.map({ $0.intValue }),
              let dailyUnits = dictionary[ResponseParams.dailyUnits.rawValue]?.dictionary,
              let hourlyUnits = dictionary[ResponseParams.hourlyUnits.rawValue]?.dictionary
        else { return nil }
        self.latitude = CLLocationDegrees(floatLiteral: latitude)
        self.longitude = CLLocationDegrees(floatLiteral: longitude)
        let weatherUnitsJSON = JSON(dailyUnits.merging(hourlyUnits, uniquingKeysWith: { current, _ in current }))
        
        weatherUnits = try JSONDecoder().decode(WeatherUnits.self, from: weatherUnitsJSON.rawData())
        
        let dailyWeather = parseDailyWeather(dailyDictionary: dailyDictionary,
                                             humidityArray: humidityArray,
                                             timezoneIdentifier: timezoneIdentifier,
                                             weatherUnits: weatherUnits)
        let hourlyWeather = parseHourlyWeather(hourlyDictionary: hourlyDictionary,
                                               timezoneIdentifier: timezoneIdentifier,
                                               weatherUnits: weatherUnits)
        
        weather = parseWeatherDictionary(dailyWeather: dailyWeather,
                                         hourlyWeather: hourlyWeather)
    }
    
    private func parseDailyWeather(dailyDictionary: [String : JSON],
                                   humidityArray: [Int],
                                   timezoneIdentifier: String,
                                   weatherUnits: WeatherUnits) -> [Weather] {
        guard let dateArray = dailyDictionary[ResponseParams.date.rawValue]?.array?.map({ $0.stringValue }),
              let minTemperatureArray = dailyDictionary[ResponseParams.minTemperature.rawValue]?.array?.map({ $0.floatValue }),
              let maxTemperatureArray = dailyDictionary[ResponseParams.maxTemperature.rawValue]?.array?.map({ $0.floatValue }),
              let windSpeedArray = dailyDictionary[ResponseParams.maxWindSpeed.rawValue]?.array?.map({ $0.floatValue }),
              let windDirectionArray = dailyDictionary[ResponseParams.dominantWindDirection.rawValue]?.array?.map({ $0.floatValue }),
              let weathercodeArray = dailyDictionary[ResponseParams.weatherCode.rawValue]?.array?.map({ $0.intValue })
        else { return [] }
        
        var array: [Weather] = []
        
        for index in 0 ..< dateArray.count {
            let startIndex = index * 24
            let endIndex = startIndex + 23
            guard let maxHumidity = humidityArray[startIndex ... endIndex].max(),
                  let date = getDate(from: dateArray[index],
                                     with: Constants.dailyDateFormat,
                                     timezoneIdentifier: timezoneIdentifier)
            else { break }
            let windDirection = WindDirection.getWindDirectionBy(degrees: windDirectionArray[index])
            let weatherType = WeatherType.weatherTypeBy(weathercode: weathercodeArray[index])
            array.append(Weather(date: date,
                                 timezone: TimeZone(identifier: timezoneIdentifier),
                                 windDirection: windDirection,
                                 windSpeed: windSpeedArray[index],
                                 weatherType: weatherType,
                                 maxTemperature: maxTemperatureArray[index],
                                 minTemperature: minTemperatureArray[index],
                                 humidity: maxHumidity,
                                weatherUnits: weatherUnits))
        }
        return array
    }
    
    private func parseHourlyWeather(hourlyDictionary: [String: JSON],
                                    timezoneIdentifier: String,
                                    weatherUnits: WeatherUnits) -> [Weather] {
        guard let dateArray = hourlyDictionary[ResponseParams.date.rawValue]?.array?.map({ $0.stringValue }),
              let temperatureArray = hourlyDictionary[ResponseParams.temperature.rawValue]?.array?.map({ $0.floatValue }),
              let windDirectionArray = hourlyDictionary[ResponseParams.windDirection.rawValue]?.array?.map({ $0.floatValue }),
              let windSpeedArray = hourlyDictionary[ResponseParams.windSpeed.rawValue]?.array?.map({ $0.floatValue }),
              let weathercodeArray = hourlyDictionary[ResponseParams.weatherCode.rawValue]?.array?.map({ $0.intValue })
        else { return [] }
              
        var array: [Weather] = []
        
        for index in 0 ..< dateArray.count {
            guard let date = getDate(from: dateArray[index],
                                     with: Constants.hourlyDateFormat,
                                     timezoneIdentifier: timezoneIdentifier)
            else { break }
            let windDirection = WindDirection.getWindDirectionBy(degrees: windDirectionArray[index])
            let weatherType = WeatherType.weatherTypeBy(weathercode: weathercodeArray[index])
            array.append(Weather(date: date,
                                 timezone: TimeZone(identifier: timezoneIdentifier),
                                 windDirection: windDirection,
                                 windSpeed: windSpeedArray[index],
                                 weatherType: weatherType,
                                 temperature: temperatureArray[index],
                                 weatherUnits: weatherUnits))
        }
        
        return array
    }
    
    private func parseWeatherDictionary(dailyWeather: [Weather],
                                        hourlyWeather: [Weather]) -> [Weather : [Weather]]
    {
        
        let countOfHours = hourlyWeather.count / dailyWeather.count
        var dictionary: [Weather: [Weather]] = [:]
        for index in 0..<dailyWeather.count {
            let startIndex = index * countOfHours
            let endIndex = startIndex + countOfHours - 1
            dictionary[dailyWeather[index]] = Array(hourlyWeather[startIndex ... endIndex])
        }
        return dictionary
    }
    
    private func getDate(from string: String,
                         with dateFormat: String,
                         timezoneIdentifier: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: string)
        return date
    }
    
}

private struct Constants {
    static let dailyDateFormat = "yyyy-MM-dd"
    static let hourlyDateFormat = "yyyy-MM-dd'T'HH:mm"
}

enum WeatherUnitsKeys: String {
    case minTemperature = "temperature_2m_min"
    case maxTemperature = "temperature_2m_max"
    case temperature = "temperature_2m"
    case dominantWindDirection = "winddirection_10m_dominant"
    case windDirection = "winddirection_10m"
    case maxWindSpeed = "windspeed_10m_max"
    case windSpeed = "windspeed_10m"
}
