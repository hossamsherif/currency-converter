//
//  Colors.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import UIKit

extension UIColor {
    public static let customBalck = UIColor(hex: "#3E3E3E")
    public static let customWhite = UIColor(hex: "#FFFFFF")
    public static let darkBlue = UIColor(hex: "#143F67")
    public static let customRed = UIColor(hex: "#C53838")
    public static let customBlue = UIColor(hex: "#1363AA")
    
    public convenience init(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        //Defaults to black
        self.init(red: 0, green: 0, blue: 0, alpha: 1.0)
        return
    }
}
