//
//  CurrencyRateModel.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import Foundation

/*
 {
   "success":true,
   "timestamp":1617762486,
   "base":"EUR",
   "date":"2021-04-07",
   "rates":{
     "AED":4.360659,
     "AFN":92.57494,
     "ALL":123.09068,
     "AMD":635.258764,
     "ANG":2.11944, ...
 }
 **/


struct CurrencyRateModel: Decodable {
    var success:Bool
    var base: String
    var date: Date
    var rates: [String: Float]
}


