//
//  BaseAPI.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import Foundation
import Alamofire
import RxSwift


/**
 404    The requested resource does not exist.
 101    No API Key was specified or an invalid API Key was specified.
 103    The requested API endpoint does not exist.
 104    The maximum allowed API amount of monthly API requests has been reached.
 105    The current subscription plan does not support this API endpoint.
 106    The current request did not return any results.
 102    The account this API request is coming from is inactive.
 201    An invalid base currency has been entered.
 202    One or more invalid symbols have been specified.
 301    No date has been specified. [historical]
 302    An invalid date has been specified. [historical, convert]
 403    No or an invalid amount has been specified. [convert]
 501    No or an invalid timeframe has been specified. [timeseries]
 502    No or an invalid "start_date" has been specified. [timeseries, fluctuation]
 503    No or an invalid "end_date" has been specified. [timeseries, fluctuation]
 504    An invalid timeframe has been specified. [timeseries, fluctuation]
 505    The specified timeframe is too long, exceeding 365 days. [timeseries, fluctuation]
 */
enum FailureReason: Int, Error {
    case notFound = 404
    case noAPIKey = 101
    case apiEndpointNotExist = 103
    case maximumAllowedAPIAmountMonthly = 104
    case baseCurrencyAccessRestricted = 105
    case noResultReturned = 106
    case invalidBaseCurrency = 201
    case oneOrMoreInvalidSymbols = 202
    case noDateSpecified = 301
    case invalidDateAmounr = 302
    case invalidAmounr = 403
    case noOrInvalidTimeFrame = 501
    case invalidStartDate = 502
    case invalidEndDate = 503
    case invalidTimeFrame = 504
    case timeFrameTooLong = 505
    case noInternetConnection = -1
    case unknown = -100
}

protocol AppServerClientProtocol {
    func getRates(base:String) -> Observable<CurrencyRateModel>
}


class AppServerClient: AppServerClientProtocol {
    
    
    var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    

    //Note: Usually Secrets should be provided from an enviroment variable or a more secured way
    struct Secrets {
        static let apiKey = "dc4f35b3672612b6ddfa2f55a8613cea"
    }
    
    struct ServerAPI {
        static let endpoint = "http://data.fixer.io/api/latest?access_key=%@"
    }
    
    // MARK: - GetRates

    func getRates(base:String = "EUR") -> Observable<CurrencyRateModel> {
        return Observable.create { observer -> Disposable in
            let params = ["base": base]
            let apiEndpoint = String(format: ServerAPI.endpoint, Secrets.apiKey)
            AF.request(apiEndpoint, parameters: params)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            // if no error provided by alamofire return .notFound error instead.
                            observer.onError(response.error ?? FailureReason.notFound)
                            return
                        }
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                  let success = json["success"] as? Bool, success else {
                                let errorResponse = try decoder.decode(FailedResponse.self, from: data)
                                observer.onError(FailureReason(rawValue: errorResponse.error.code) ?? .unknown)
                                return
                            }
                            let rate = try decoder.decode(CurrencyRateModel.self, from: data)
                            observer.onNext(rate)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = FailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        if !self.isConnectedToInternet {
                            observer.onError(FailureReason.noInternetConnection)
                        }else {
                            observer.onError(error)
                        }
                    }
            }
            return Disposables.create()
        }
    }
}
