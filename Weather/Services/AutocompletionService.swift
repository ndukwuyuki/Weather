//
//  AutocompletionService.swift
//  Weather
//
//  Created by Yukeriia Suprun on 20.11.2022.
//

import Foundation
import MapKit

protocol AutocompletionServiceDelegate {
    func citiesUpdated()
}

class AutocompletionService: NSObject {
    
    static let shared = AutocompletionService()
    var delegate: AutocompletionServiceDelegate?
    
    private(set) var cities = [City]() {
        didSet {
            delegate?.citiesUpdated()
        }
    }
    
    private(set) var searchCompleter = MKLocalSearchCompleter()
    
    fileprivate override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType.address
    }
    
    private func getCityList(results: [MKLocalSearchCompletion]) {
        var searchResults: [City] = []
        let digitsCharacterSet = NSCharacterSet.decimalDigits
        let filteredResults = results.filter({ $0.title.rangeOfCharacter(from: digitsCharacterSet) == nil && $0.subtitle.rangeOfCharacter(from: digitsCharacterSet) == nil })
            
        for result in filteredResults {
            
            let titleComponents = result.title.components(separatedBy: ", ")
            let subtitleComponents = result.subtitle.components(separatedBy: ", ")
            if subtitleComponents.count > 2 { break }
            if titleComponents.count > 0, subtitleComponents.count > 0 {
                let city = titleComponents.first ?? ""
                var country = ""
                if subtitleComponents.count > 1 {
                    country = subtitleComponents.last ?? ""
                } else if subtitleComponents[0] != "" {
                    country = subtitleComponents.first ?? ""
                } else {
                    country = titleComponents.last ?? ""
                }
                searchResults.append(City(country: country, city: city))
            }
        }
            
            cities = searchResults
    }
    
}

extension AutocompletionService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        getCityList(results: completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
