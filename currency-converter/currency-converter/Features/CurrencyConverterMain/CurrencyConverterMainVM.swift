//
//  CurrencyConverterMainVM.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import Foundation
import RxSwift
import RxCocoa


protocol CurrencyConverterMainVMProtocol {
    /// rates against current base
    var rates: Observable<[CurrencyCellVM]> { get }
    /// indicate network loading progress
    var loadInProgress: Observable<Bool> { get }
    /// emit current base curreny model
    var currentCurrency: Observable<CurrencyDisplay> { get }
    /// Emit all currencies for currency selection
    var currencies: Observable<[CurrencyDisplay]> { get }
    /// for showing error with reason
    var onShowError: PublishSubject<ErrorBannerType> { get }
    /// request all rate against a specific base
    func getRates(base:String?)
    /// select a new base rate
    func selectNewBase(index:Int)
}

extension CurrencyConverterMainVMProtocol {
    func getRates() {
        getRates(base: nil)
    }
}

struct CurrencyDisplay {
    var title:String
    var icon:String?
}

class CurrencyConverterMainVM: CurrencyConverterMainVMProtocol {
    
    let onShowError = PublishSubject<ErrorBannerType>()
    
    var rates: Observable<[CurrencyCellVM]> {
        return _rates.asObservable()
    }
    private let _rates = BehaviorRelay<[CurrencyCellVM]>(value: [])
    
    var currencies: Observable<[CurrencyDisplay]> {
        return _currencies.asObservable()
    }
    private let _currencies = BehaviorRelay<[CurrencyDisplay]>(value: [])
    
    var loadInProgress: Observable<Bool> {
        return _loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    private let _loadInProgress = BehaviorRelay(value: false)
    
    var currentCurrency: Observable<CurrencyDisplay> {
        return _currentCurrency.asObservable()
    }
    private let _currentCurrency = BehaviorRelay<CurrencyDisplay>(value: CurrencyDisplay(title: "EUR", icon: ""))
    
    
    private let appServerClient: AppServerClientProtocol
    
    private let defaultBase = "EUR"
    
    private let disposeBag = DisposeBag()
    
    init(appServerClient: AppServerClientProtocol = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    func getRates(base:String? = nil) {
        //Start loader
        _loadInProgress.accept(true)
        appServerClient
            .getRates(base: defaultBase)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    //Stop loader
                    self._loadInProgress.accept(false)
                    //Sort rates
                    let rates = response.rates.sorted { (e1, e2) -> Bool in
                        e1.key < e2.key
                    }
                    //Check if base is provided
                    //Then recallculate new rate from EUR data
                    //Since it is the only provided data for free plan
                    if let base = base,
                       let newRate = rates.first(where: { (key,_) in key == base }) {
                        //emit current selected base and rate
                        self._currentCurrency.accept(CurrencyDisplay(title: base, icon: CountryFlagHelper.flagEmoji(base)))
                        let newRates = rates.map{ CurrencyCellVM(title: $0, rate: $1 / newRate.value) }
                        //emit new rates
                        self._rates.accept(newRates)
                    }else { //Calculate normaly with default base of EUR
                        self._currentCurrency.accept(CurrencyDisplay(title: response.base, icon: CountryFlagHelper.flagEmoji(response.base)))
                        self._rates.accept(rates.map{ CurrencyCellVM(title: $0, rate: $1) })
                        if self._currencies.value.isEmpty{
                            let currArr = rates.map({ (key, _) in
                                CurrencyDisplay(title: key, icon: CountryFlagHelper.flagEmoji(key))
                            }).sorted{ $0.title < $1.title }
                            self._currencies.accept(currArr)
                        }
                    }
                },
                onError: { [weak self] error in
                    self?._loadInProgress.accept(false)

                    if let error =  error as? FailureReason, error == .noInternetConnection {
                        self?.onShowError.onNext(.noInternetConnection)
                    }else{
                        self?.onShowError.onNext(.somethingWentWrong)
                    }
                    
                    
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func selectNewBase(index: Int) {
        guard index < _currencies.value.count else { return }
        let newBase = _currencies.value[index]
        getRates(base: newBase.title)
        _currentCurrency.accept(newBase)
    }
    
}
