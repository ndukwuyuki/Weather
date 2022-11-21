//
//  CityTableViewCell.swift
//  Weather
//
//  Created by Yukeriia Suprun on 21.11.2022.
//

import UIKit
import SnapKit

class CityTableViewCell: UITableViewCell {
    
    var cityName: String? {
        didSet {
            cityNameLabel.text = cityName
        }
    }
    
    private let cityNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureCityNameLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
        configureCityNameLabel()
    }
    
    private func configureCityNameLabel() {
        cityNameLabel.font = UIConstants.font
        cityNameLabel.textColor = .black
        
        contentView.addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(27)
            make.bottom.equalToSuperview().inset(7)
            make.height.equalTo(17)
        }
    }

}

private struct UIConstants {
    static let font = UIFont(name: "CourierNewPSMT", size: 20) ?? UIFont.systemFont(ofSize: 20)
}
