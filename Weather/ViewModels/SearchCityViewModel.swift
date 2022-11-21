//
//  SearchCityViewModel.swift
//  Weather
//
//  Created by Yukeriia Suprun on 20.11.2022.
//

import Foundation
import RxSwift

class SearchCityViewModel {
    let filteredCities = BehaviorSubject(value: [CityViewModel]())
    private var allCities = [CityViewModel]()
    
    let searchValue = PublishSubject<String>()
    
    let selectedCity = PublishSubject<CityViewModel>()
    
    lazy var searchValueObservable = searchValue.asObservable()
    private let disposeBag = DisposeBag()
    
    init() {
        AutocompletionService.shared.delegate = self
        searchValueObservable.subscribe(onNext:{ value in
            AutocompletionService.shared.searchCompleter.queryFragment = value
        }).disposed(by: disposeBag)
    }
    
}

extension SearchCityViewModel: AutocompletionServiceDelegate {
    func citiesUpdated() {
        let filteredCities = AutocompletionService.shared.cities.map { CityViewModel(city: $0) }
        self.filteredCities.onNext(filteredCities)
    }
    
    
}
