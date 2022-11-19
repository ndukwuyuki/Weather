//
//  HourlyWeatherCollectionViewCell.swift
//  Weather
//
//  Created by Yukeriia Suprun on 18.11.2022.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    var time: NSMutableAttributedString? {
        didSet {
            timeLabel.attributedText = time
        }
    }
    
    var weatherImage: UIImage? {
        didSet {
            weatherImageView.image = weatherImage
        }
    }
    
    var temperature: String? {
        didSet {
            temperatureLabel.text = temperature
        }
    }
    
    private let timeLabel = UILabel()
    private let weatherImageView = UIImageView()
    private let temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        configureTimeLabel()
        configureWeatherImageView()
        configureTemperatureLabel()
    }
    
    private func configureTimeLabel() {
        timeLabel.textAlignment = .center
        timeLabel.textColor = .white
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(28)
            make.height.equalTo(23)
        }
    }
    
    private func configureWeatherImageView() {
        weatherImageView.tintColor = .white
        weatherImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().inset(35)
            make.width.equalTo(50)
            make.top.equalTo(timeLabel.snp.bottom).offset(18)
            make.height.equalTo(50)
        }
    }
    
    private func configureTemperatureLabel() {
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = .white
        temperatureLabel.font = UIConstants.temperatureFont
        
        contentView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(weatherImageView.snp.bottom)
            make.bottom.equalToSuperview().inset(28)
            make.height.equalTo(23)
        }
    }
    
}

private struct UIConstants {
    static let temperatureFont = UIFont(name: "CourierNewPS-BoldMT", size: 24) ?? UIFont.systemFont(ofSize: 24)
}
