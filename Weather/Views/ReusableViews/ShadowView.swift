//
//  ShadowView.swift
//  Weather
//
//  Created by Yukeriia Suprun on 19.11.2022.
//

import UIKit

class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setShadow()
    }
    
    private func setShadow() {
        backgroundColor = .white
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = UIConstants.shadowColor
        layer.shadowOpacity = UIConstants.shadowOpacity
        layer.shadowRadius = UIConstants.shadowRadius
        layer.shadowOffset = UIConstants.shadowOffset
    }
    
}

private struct UIConstants {
    static let shadowColor = UIColor(red: 90.0/255.0, green: 159.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
    static let shadowOffset = CGSize.zero
    static let shadowRadius = 15.0
    static let shadowOpacity: Float = 0.25
}
