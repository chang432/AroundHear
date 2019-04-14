//
//  UIView+Extension.swift
//  AroundHear
//
//  Created by Andre Chang on 4/11/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)

        layer.insertSublayer(gradientLayer, at: 0)
    }
}
