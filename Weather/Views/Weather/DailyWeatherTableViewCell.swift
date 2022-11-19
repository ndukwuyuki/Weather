//
//  DailyWeatherTableViewCell.swift
//  Weather
//
//  Created by Yukeriia Suprun on 18.11.2022.
//

import UIKit
import SnapKit

class DailyWeatherTableViewCell: UITableViewCell {
    
    var isTopCell: Bool = false {
        didSet {
            configureSubviews()
        }
    }
    
    var weekday: String? {
        didSet {
            weekdayLabel.text = weekday
            weekdayLabel.sizeToFit()
        }
    }
    
    var temperature: String? {
        didSet {
            temperatureLabel.text = temperature
        }
    }
    
    var weatherImage: UIImage? {
        didSet {
            weatherImageView.image = weatherImage
        }
    }
    
    private let shadowView = ShadowView()
    private let weekdayLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSelfView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSelfView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        shadowView.isHidden = !selected
        
        weekdayLabel.textColor = selected ? UIConstants.selectedColor : .black
        temperatureLabel.textColor = selected ? UIConstants.selectedColor : .black
        weatherImageView.tintColor = selected ? UIConstants.selectedColor : .black
    }
    
    private func configureSelfView() {
        selectionStyle = .none
        backgroundColor = .white
        
    }
    
    private func configureSubviews() {
        backgroundColor = .white
        configureShadowView()
        configureWeekdayLabel()
        configureTemperatureLabel()
        configureWeatherImageView()
    }
    
    private func configureShadowView() {
        contentView.addSubview(shadowView)
        
        if isTopCell {
            shadowView.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(15)
            }
        } else {
            shadowView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.bottom.equalToSuperview().offset(15)
            }
        }
        
        contentView.sendSubviewToBack(shadowView)
    }
    
    private func configureWeekdayLabel() {
        weekdayLabel.textColor = .black
        weekdayLabel.highlightedTextColor = UIConstants.selectedColor
        weekdayLabel.font = UIConstants.font
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let topOffset = isTopCell ? 28 : 43
        
        contentView.addSubview(weekdayLabel)
        weekdayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21.5)
            make.top.equalToSuperview().offset(topOffset)
            make.bottom.equalToSuperview().inset(13)
            make.height.equalTo(21)
            make.width.equalTo(30)
        }
    }
    
    private func configureTemperatureLabel() {
        temperatureLabel.font = UIConstants.font
        temperatureLabel.textAlignment = .center
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.leading.equalTo(weekdayLabel.snp.trailing)
            make.top.bottom.equalTo(weekdayLabel)
        }
    }
    
    private func configureWeatherImageView() {
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let topOffset = isTopCell ? 0 : 15
        
        contentView.addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.leading.equalTo(temperatureLabel.snp.trailing)
            make.centerY.equalTo(weekdayLabel.snp.centerY)
            make.top.equalToSuperview().offset(topOffset)
            make.width.equalTo(40)
            make.trailing.equalToSuperview().inset(21)
        }
    }
    
}

private struct UIConstants {
    static let font = UIFont(name: "CourierNewPS-BoldMT", size: 24) ?? UIFont.systemFont(ofSize: 24)
    static let selectedColor = UIColor(red: 90.0/255.0, green: 159.0/255.0, blue: 240.0/255.0, alpha: 1.0)
}
