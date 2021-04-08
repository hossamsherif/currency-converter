//
//  UIFont+CustomFont.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/8/21.
//

import Foundation
import UIKit

enum FontWeight {
    case bold
    case medium
    case regular
    
    func description() -> String {
        switch self {
        case .bold: return "Roboto-Bold"
        case .medium: return "Roboto-Medium"
        case .regular: return "Roboto-Regular"
        }
    }
}

extension UIFont {
    class func customFont(size:CGFloat, weight: FontWeight) -> UIFont? {
        UIFont(name: weight.description(), size: size)
    }
}
