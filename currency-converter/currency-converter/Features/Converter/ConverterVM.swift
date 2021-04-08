//
//  ConverterVM.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import RxSwift
import RxCocoa

protocol ConverterVMProtocol {
    /// current amount
    var amount: BehaviorRelay<String> { get }
    /// converted result
    var result: Observable<String> { get }
    /// current result currency
    var resultCurrency: Observable<String> { get }
    /// current amount (base) currency
    var amountCurrency: Observable<String> { get }
    /// showing error with reason
    var onShowError: PublishSubject<ErrorBannerType> { get }
    /// hide error
    var onHideError: PublishSubject<()> { get }    
}


class ConverterVM: ConverterVMProtocol {
    
    var amount = BehaviorRelay<String>(value: "1")
    
    var resultCurrency: Observable<String> {
        return _resultCurrency.asObservable()
    }
    private var _resultCurrency = BehaviorRelay<String>(value: "")
    
    var amountCurrency: Observable<String> {
        return _amountCurrency.asObservable()
    }
    private var _amountCurrency = BehaviorRelay<String>(value: "")
    
    
    var result: Observable<String> {
        return convertedResult.asObservable()
    }
    
    var onShowError = PublishSubject<ErrorBannerType>()
    var onHideError = PublishSubject<()>()
    
    private let disposeBag = DisposeBag()
    private let convertedResult = BehaviorRelay<String>(value: "")
    
    private var rate: Float
    private var base: String
    private var toConvert: String
    
    init(base: String, toConvert:String, rate: Float) {
        self.rate = rate
        self.base = base
        self.toConvert = toConvert
        setupObservation()
        _amountCurrency.accept(base)
        _resultCurrency.accept(toConvert)
    }
    
    func setupObservation() {
        amount.asObservable()
            .map{
                $0.isEmpty ? "0" : $0
            }
            .subscribe(
                onNext: { [weak self] in
                    guard let self = self else { return }
                    if let amount = Float($0) {
                        self.convertedResult.accept(String(format: "%.2f", amount*self.rate))
                        self.onHideError.onNext(())
                    }else{
                        self.convertedResult.accept("0.0")
                        self.onShowError.onNext(.worngNumberFormat)
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    
    
    
}
