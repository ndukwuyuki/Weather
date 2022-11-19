//
//  SelectedWeatherView.swift
//  Weather
//
//  Created by Yukeriia Suprun on 15.11.2022.
//

import UIKit
import SnapKit

protocol SelectedWeatherViewDelegate {
    func didTapOnCity()
    func didTapOnLocation()
}

class SelectedWeatherView: UIView {
    var delegate: SelectedWeatherViewDelegate?
    
    var cityName: String? {
        didSet {
            cityNameLabel.text = cityName
        }
    }
    
    var dateString: String? {
        didSet {
            dateLabel.text = dateString
        }
    }
    
    var weatherImage: UIImage? {
        didSet {
            weatherImageView.image = weatherImage
        }
    }
    
    var temperatureString: String? {
        didSet {
            temperatureLabel.text = temperatureString
        }
    }
    
    var humidityString: String? {
        didSet {
            humidityLabel.text = humidityString
        }
    }
    
    var windSpeedString: String? {
        didSet {
            windLabel.text = windSpeedString
            windLabel.sizeToFit()
        }
    }
    
    var windDirectionImage: UIImage? {
        didSet {
            windDirectionImageView.image = windDirectionImage
        }
    }
    
    private var markerImageView = UIImageView(image: ImageFactory.markerImage)
    private var cityNameLabel = UILabel()
    private var locationImageView = UIImageView(image: ImageFactory.locationImage)
    private var dateLabel = UILabel()
    private var weatherImageView = UIImageView()
    private var temperatureImageView = UIImageView(image: ImageFactory.temperatureImage)
    private var temperatureLabel = UILabel()
    private var humidityImageView = UIImageView(image: ImageFactory.humidityImage)
    private var humidityLabel = UILabel()
    private var windImageView = UIImageView(image: ImageFactory.windImage)
    private var windLabel = UILabel()
    private var windDirectionImageView = UIImageView()
    
    private let font = UIFont(name: "CourierNewPS-BoldMT", size: 30) ?? UIFont.systemFont(ofSize: 30)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        configureSubviews()
    }
    
    private func configureSubviews() {
        configureMarkerImageView()
        configureCityNameLabel()
        configureLocationImageView()
        configureDateLabel()
        configureWeatherImageView()
        configureTemperatureImageView()
        configureTemperatureLabel()
        configureHumidityImageView()
        configureHumidityLabel()
        configureWindImageView()
        configureWindSpeedLabel()
        configureWindDirectionImageView()
        
    }
    
    private func configureMarkerImageView() {
        markerImageView.contentMode = .scaleAspectFit
        markerImageView.tintColor = .white
        markerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(markerImageView)
        markerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.leading.equalToSuperview().offset(17.5)
            make.height.width.equalTo(25)
        }
    }
    
    private func configureCityNameLabel() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectedWeatherView.didTapOnCity))
        cityNameLabel.addGestureRecognizer(tapRecognizer)
        cityNameLabel.isUserInteractionEnabled = true
        cityNameLabel.textColor = .white
        cityNameLabel.font = UIConstants.cityNameFont
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(markerImageView)
            make.leading.equalTo(markerImageView.snp.trailing).offset(10)
        }
    }
    
    private func configureLocationImageView() {
        locationImageView.contentMode = .scaleAspectFit
        locationImageView.tintColor = .white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectedWeatherView.didTapOnLocation))
        locationImageView.addGestureRecognizer(tapGestureRecognizer)
        locationImageView.isUserInteractionEnabled = true
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(locationImageView)
        locationImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(markerImageView)
            make.leading.equalTo(cityNameLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(17.5)
            make.width.equalTo(25)
        }
    }
    
    private func configureDateLabel() {
        dateLabel.textColor = .white
        dateLabel.font = UIConstants.dateFont
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(markerImageView).offset(4)
            make.top.equalTo(markerImageView.snp.bottom).offset(15)
            make.height.equalTo(15)
        }
    }
    
    private func configureWeatherImageView() {
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.tintColor = .white
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalTo(snp.centerX)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configureTemperatureImageView() {
        temperatureImageView.contentMode = .scaleAspectFit
        temperatureImageView.tintColor = .white
        temperatureImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(temperatureImageView)
        temperatureImageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(50)
            make.leading.equalTo(weatherImageView.snp.trailing).offset(7.5)
            make.height.width.equalTo(23)
        }
    }
    
    private func configureTemperatureLabel() {
        temperatureLabel.textColor = .white
        temperatureLabel.font = UIConstants.indicatorsFont
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(temperatureImageView)
            make.leading.equalTo(temperatureImageView.snp.trailing).offset(14)
        }
    }
    
    private func configureHumidityImageView() {
        humidityImageView.contentMode = .scaleAspectFit
        humidityImageView.tintColor = .white
        humidityImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(humidityImageView)
        
        humidityImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(temperatureImageView)
            make.top.equalTo(temperatureImageView.snp.bottom).offset(11)
            make.height.equalTo(temperatureImageView)
        }
    }
    
    private func configureHumidityLabel() {
        humidityLabel.textColor = .white
        humidityLabel.font = UIConstants.indicatorsFont
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(humidityLabel)
        
        humidityLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(humidityImageView)
            make.leading.equalTo(temperatureLabel)
        }
    }
    
    private func configureWindImageView() {
        windImageView.contentMode = .scaleAspectFit
        windImageView.tintColor = .white
        windImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(windImageView)
        
        windImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(humidityImageView)
            make.top.equalTo(humidityImageView.snp.bottom).offset(11)
            make.height.equalTo(humidityImageView)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func configureWindSpeedLabel() {
        windLabel.textColor = .white
        windLabel.font = UIConstants.indicatorsFont
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(windLabel)
        
        windLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(windImageView)
            make.leading.equalTo(humidityLabel)
        }
    }
    
    private func configureWindDirectionImageView() {
        windDirectionImageView.contentMode = .scaleAspectFit
        windDirectionImageView.tintColor = .white
        windDirectionImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(windDirectionImageView)
        
        windDirectionImageView.snp.makeConstraints { make in
            make.leading.equalTo(windLabel.snp.trailing)
            make.centerY.equalTo(windLabel)
            make.width.height.equalTo(35)
        }
    }
    
    @objc private func didTapOnCity() {
        delegate?.didTapOnCity()
    }
    
    @objc private func didTapOnLocation() {
        delegate?.didTapOnLocation()
    }
}

private struct UIConstants {
    static let cityNameFont = UIFont(name: "CourierNewPS-BoldMT", size: 30) ?? UIFont.systemFont(ofSize: 30)
    static let dateFont = UIFont(name: "CourierNewPS-BoldMT", size: 16) ?? UIFont.systemFont(ofSize: 16)
    static let indicatorsFont = UIFont(name: "CourierNewPS-BoldMT", size: 24) ?? UIFont.systemFont(ofSize: 24)
}
