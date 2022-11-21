//
//  MapViewController.swift
//  Weather
//
//  Created by Yukeriia Suprun on 21.11.2022.
//

import UIKit
import MapKit
import SnapKit
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    var coordinator: MapCoordinatorInput?
    var viewModel: MapViewModel? {
        didSet {
            viewModel?.set(locationManager: locationManager)
            configureBindings()
        }
    }
    
    private var mapView: MKMapView?
    private var myLocationButton: UIButton?
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        configureSubviews()
        configureBindings()
        // Do any additional setup after loading the view.
    }
    
    private func configureSubviews() {
        configureNavigationBar()
        configureMapView()
        configureTapGestureRecognizer()
        configureMyLocationButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageFactory.backImage?.withTintColor(.white),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(MapViewController.backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(MapViewController.submitButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func configureMapView() {
        mapView = MKMapView(frame: view.frame)
        mapView?.showsUserLocation = true
        mapView?.delegate = self
        guard let mapView = mapView else { return }
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.leading.trailing.equalToSuperview()
        })
    }
    
    private func configureTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(MapViewController.handleTap(_:)))
        mapView?.addGestureRecognizer(tapRecognizer)
    }
    
    private func configureMyLocationButton() {
        myLocationButton = UIButton(frame: CGRect(origin: .zero,
                                                  size: CGSize(width: 50,
                                                               height: 50)))
        myLocationButton?.setImage(ImageFactory.locationImage, for: .normal)
        myLocationButton?.addTarget(self,
                                    action: #selector(MapViewController.myLocationTapped),
                                    for: .touchDown)
        
        
        guard let myLocationButton = myLocationButton else { return }
        view.addSubview(myLocationButton)
        
        myLocationButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.trailing.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func configureBindings() {
        viewModel?.annotation.subscribe(onNext: { [weak self] annotation in
            self?.mapView?.addAnnotation(annotation)
        }).disposed(by: disposeBag)
        viewModel?.region.subscribe(onNext: { [weak self] region in
            self?.mapView?.setRegion(region, animated: true)
        }).disposed(by: disposeBag)
    }
    
    @objc private func myLocationTapped() {
        viewModel?.getMyLocation()
    }
    
    @objc private func submitButtonTapped() {
        guard let annotation = mapView?.annotations.last
        else {
            coordinator?.back()
            return
        }
        
        coordinator?.didChangeLocation(to: annotation.coordinate)
    }
    
    @objc private func backButtonTapped() {
        coordinator?.back()
    }
    
    @objc private func handleTap(_ tapRecognizer: UITapGestureRecognizer) {
        guard let mapView = mapView else { return }
        viewModel?.handleTap(gestureRecognizer: tapRecognizer, mapView: mapView)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.centerCoordinate)
    }
}
