//
//  ViewController.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/6/21.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

class CurrencyConverterMainVC: UIViewController {
    
    private let currencyConverterMainView = CurrencyConverterMainView()
    private var viewModel:CurrencyConverterMainVMProtocol!
    private var errorBannerManager: ErrorBannerManagerProtocol!
    private let disposeBag = DisposeBag()
    
    private var currencySelectorPicker = ToolBarPickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(currencyConverterMainView)
        currencyConverterMainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        navigationController?.setNavigationBarHidden(true, animated: false)
        currencyConverterMainView.setupView()
        setupCellSelection()
        setupCurrencySelector()
        bindVM()
        viewModel.getRates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currencyConverterMainView.applyHeaderGradient()
    }
    
    class func create(viewModel:CurrencyConverterMainVMProtocol,
                      errorbannerManager:ErrorBannerManagerProtocol = ErrorBannerManager.shared) -> CurrencyConverterMainVC {
        let viewController = CurrencyConverterMainVC()
        viewController.viewModel = viewModel
        viewController.errorBannerManager = errorbannerManager
        return viewController
    }
    
    func bindVM() {
        
        viewModel.loadInProgress.subscribe(
            onNext: { [weak self] in
                $0 ? self?.currencyConverterMainView.refreshControl.beginRefreshing() : self?.currencyConverterMainView.refreshControl.endRefreshing()
            },
            onError: {  [weak self] error in
                print(error)
                self?.currencyConverterMainView.refreshControl.endRefreshing()
            }
        ).disposed(by: disposeBag)
        
        currencyConverterMainView.refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                let currentBase = self?.currencyConverterMainView.currentCurrencyLabel.text
                self?.viewModel.getRates(base: currentBase)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentCurrency.subscribe(
            onNext: { [weak self] in
                self?.currencyConverterMainView.currentCurrencyLabel.text = $0.title
                self?.currencyConverterMainView.currentCurrencyIconLabel.label.text = $0.icon
            }
        ).disposed(by: disposeBag)
        
        viewModel.rates.bind(to: currencyConverterMainView.tableView.rx.items) { tableView, index, cellVM  in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(CurrencyCell.self)", for: indexPath) as! CurrencyCell
            cell.viewModel = cellVM
            return cell
        }.disposed(by: disposeBag)
        
        viewModel
            .onShowError
            .map { [weak self] in self?.showError(errorType: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        
    }
    
    func setupCellSelection() {
        currencyConverterMainView.tableView
            .rx
            .modelSelected(CurrencyCellVM.self)
            .subscribe(
                onNext: { [weak self] vm in
                     guard let base = self?.currencyConverterMainView.currentCurrencyLabel.text else {
                        //error
                        return
                     }
                    let toConvert = vm.title
                    let rate = vm.rate
                    let vc = ConverterVC.create(viewModel: ConverterVM(base: base, toConvert: toConvert, rate: rate))
                    self?.navigationController?.pushViewController(vc, animated: true)
                    if let selectedRowIndexPath = self?.currencyConverterMainView.tableView.indexPathForSelectedRow {
                        self?.currencyConverterMainView.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    @objc func showCurrencySelector() {
        if !currencySelectorPicker.isBeingPresented {
            currencySelectorPicker.modalPresentationStyle = .overCurrentContext
            currencySelectorPicker.modalTransitionStyle = .crossDissolve
            self.present(currencySelectorPicker, animated: true, completion: nil)
        }
    }
    
    func setupCurrencySelector() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCurrencySelector))
        currencyConverterMainView.header.addGestureRecognizer(tapGesture)
        
        viewModel.currencies.bind(to: currencySelectorPicker.picker.rx.itemTitles) { (row, element) in
            return "\(element.icon ?? "") \(element.title)"
        }
        .disposed(by: disposeBag)
        
        currencySelectorPicker.delegate = self
    }
    
    func showError(errorType:ErrorBannerType) {
        errorBannerManager.showErrorBanner(errorType: errorType)
    }
    
    
}

extension CurrencyConverterMainVC: ToolBarPickerDelegate {
    
    func doneAction() {
        viewModel.selectNewBase(index: currencySelectorPicker.picker.selectedRow(inComponent: 0))
        currencySelectorPicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelAction() {
        currencySelectorPicker.dismiss(animated: true, completion: nil)
    }
}


