//
//  FailureResponse.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/8/21.
//

import Foundation

struct FailedResponse: Decodable {
    struct ErrorModel: Decodable {
        var code: Int
        var type: String
    }
    var success: Bool
    var error: ErrorModel
}
