//
//  CountryFlagHelper.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import Foundation



class CountryFlagHelper {
    
    static let noIconCurreny = ["XCD","ANG","XPF","XAF","XOF","XAU","XDR","XAG"]
    
    static func flagEmoji(_ currencyCode:String) -> String? {
        guard !noIconCurreny.contains(currencyCode) else { return nil }
        let base: UInt32 = 127397
        let code = String(currencyCode.prefix(2))
        var result = ""
        code.unicodeScalars.forEach{ result.unicodeScalars.append(UnicodeScalar(base + $0.value)!) }
        return result
    }
    
}
