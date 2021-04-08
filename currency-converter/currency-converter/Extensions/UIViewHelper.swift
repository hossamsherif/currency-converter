//
//  UIViewHelper.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import Foundation
import UIKit


extension UIView {
    
    
    func applyShadow(color: UIColor, radius: CGFloat, opacity: Float, offset:CGSize) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shouldRasterize = true
    }
    
    func dropShadow() {
        applyShadow(color: .black, radius: 10.0, opacity: 0.3, offset: CGSize(width: 0, height: 3))
    }
    
    
    func setGradientBackground(topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func addSubviews(_ views:UIView ...) {
        views.forEach { addSubview($0) }
    }
    
}
