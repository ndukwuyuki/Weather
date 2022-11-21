//
//  MapViewModel.swift
//  Weather
//
//  Created by Yukeriia Suprun on 21.11.2022.
//

import Foundation
import CoreLocation
import MapKit
import RxSwift
import RxCocoa

class MapViewModel: NSObject {
    
    let annotation = PublishSubject<MKPointAnnotation>()
    let region = PublishSubject<MKCoordinateRegion>()
    let usersLocation = PublishSubject<CLLocation>()
    
    var usersLocationDriver: Driver<CLLocation> {
        usersLocation.asDriver { _ in return .empty()}
    }
    
    private let disposeBag = DisposeBag()
    private var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        
        usersLocationDriver.drive(onNext: { [weak self] location in
            let region = MKCoordinateRegion(center: location.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.02,
                                                                   longitudeDelta: 0.02))
            self?.region.onNext(region)
        }).disposed(by: disposeBag)
    }
    
    func set(locationManager: CLLocationManager?) {
        self.locationManager = locationManager
        self.locationManager?.delegate = self
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer, mapView: MKMapView) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint,
                                          toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.annotation.onNext(annotation)
    }
    
    func getMyLocation() {
        locationManager?.startUpdatingLocation()
    }
    
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        usersLocation.onNext(location)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
