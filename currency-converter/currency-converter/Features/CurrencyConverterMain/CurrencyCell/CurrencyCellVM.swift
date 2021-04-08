//
//  CurrencyCellVM.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import Foundation


protocol CurrencyCellVMProtocol {
    var icon: String? { get }
    var title: String { get }
    var rateValue: String { get}
}

class CurrencyCellVM: CurrencyCellVMProtocol {
    var icon:String?
    var title: String
    var rate: Float
    
    var rateValue: String {
        String(format: "%.2f", rate)
    }
    
    init(title:String, rate: Float) {
        self.title = title
        self.rate = rate
        self.icon = CountryFlagHelper.flagEmoji(title)
    }
}
