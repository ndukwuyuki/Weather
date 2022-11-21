//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Yukeriia Suprun on 18.11.2022.
//

import UIKit

struct WeatherViewModel {
    private let weather: Weather
    
    var id: UUID {
        return weather.id
    }
    
    var day: String {
        let date = weather.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        dateFormatter.locale = Locale(identifier: "uk_UA")
        dateFormatter.shortWeekdaySymbols = dateFormatter.shortWeekdaySymbols.map({ $0.localizedUppercase })
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    var weekday: String {
        let date = weather.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "uk_UA")
        dateFormatter.timeZone = weather.timezone
        dateFormatter.shortWeekdaySymbols = dateFormatter.shortWeekdaySymbols.map({ $0.localizedUppercase })
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    var time: NSMutableAttributedString {
        let font = UIFont(name: "CourierNewPS-BoldMT", size: 22) ?? UIFont.systemFont(ofSize: 22)
        let fontSuper = UIFont(name: "CourierNewPS-BoldMT", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = weather.timezone
        dateFormatter.dateFormat = "HHmm"
        let dateString = dateFormatter.string(from: weather.date)
        let attrDate = NSMutableAttributedString(string: dateString, attributes: [.font: font])
        attrDate.setAttributes([.font: fontSuper,
                                .baselineOffset: 5],
                               range: NSRange(location: 2, length: 2))
        return attrDate
    }
    
    var windDirection: UIImage? {
        return ImageFactory.windDirectionImage(for: weather.windDirection)
    }
    
    var windSpeed: String {
        return "\(Int(weather.windSpeed))\(weather.weatherUnits.windSpeedUnit)"
    }
    
    var weatherType: UIImage? {
        return ImageFactory.weatherImage(for: weather.weatherType)
    }
    
    var temperature: String {
        if let temperature = weather.temperature {
            return "\(Int(temperature))\(weather.weatherUnits.temperatureUnit)"
        } else if let maxTemperature = weather.maxTemperature,
                    let minTemperature = weather.minTemperature {
            return "\(Int(maxTemperature))\(weather.weatherUnits.temperatureUnit)/\(Int(minTemperature))\(weather.weatherUnits.temperatureUnit)"
        } else {
            return ""
        }
    }
    
    var humidity: String {
        guard let humidity = weather.humidity else { return ""}
        return "\(humidity)\(weather.weatherUnits.humidityUnit)"
    }
    
    init(weather: Weather) {
        self.weather = weather
    }
}
