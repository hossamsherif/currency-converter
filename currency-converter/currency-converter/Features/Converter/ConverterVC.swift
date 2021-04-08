//
//  ConverterVC.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import Foundation
import UIKit
import RxSwift

class ConverterVC: UIViewController {
    
    private let converterView = ConverterView()
    private var viewModel: ConverterVMProtocol!
    private var errorBannerManager: ErrorBannerManagerProtocol!
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(converterView)
        converterView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        converterView.setupView()
        addToolbar()
        bindVM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        converterView.amountTF.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        converterView.applyGradient()
    }
    
    class func create(viewModel:ConverterVMProtocol,
                      errorbannerManager:ErrorBannerManagerProtocol = ErrorBannerManager.shared) -> ConverterVC {
        let viewController = ConverterVC()
        viewController.viewModel = viewModel
        viewController.errorBannerManager = errorbannerManager
        return viewController
    }
    
    private func addToolbar() {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(popVC))
        bar.items = [cancelBtn]
        bar.sizeToFit()
        bar.translatesAutoresizingMaskIntoConstraints = false
        converterView.amountTF.inputAccessoryView = bar
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func bindVM() {
        viewModel.result.bind(to: converterView.resultLabel.rx.text).disposed(by: disposeBag)
        viewModel.amountCurrency.bind(to: converterView.amountCurrencyLabel.rx.text).disposed(by: disposeBag)
        viewModel.resultCurrency.bind(to: converterView.resultCurrencyLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.amount
            .filter{[weak self] in $0 != self?.converterView.amountTF.text }
            .bind(to: converterView.amountTF.rx.text)
            .disposed(by: disposeBag)
        converterView.amountTF.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.amount)
            .disposed(by: disposeBag)
        
        viewModel.onShowError.map { [weak self] in self?.errorBannerManager.showErrorBanner(errorType: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.onHideError.map { [weak self] in self?.errorBannerManager.hideErrorBanner() }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
