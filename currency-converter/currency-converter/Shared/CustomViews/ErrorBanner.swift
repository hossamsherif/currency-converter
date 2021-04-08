//
//  ErrorBanner.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/8/21.
//

import Foundation
import UIKit
import SnapKit
import SwiftMessages

class ErrorBannerView: UIView {
    
    var errorType: ErrorBannerType = .somethingWentWrong {
        didSet {
            errorLabel.attributedText = errorType.description()
        }
    }
    
    let errorLabel: UILabel = {
        let errorLabel = UILabel()
        return errorLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .customWhite
        addSubview(errorLabel)
        
        errorLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(CGFloat.bigMargin)
            make.trailing.equalToSuperview().offset(-CGFloat.margin)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

enum ErrorBannerType {
    case somethingWentWrong
    case worngNumberFormat
    case noInternetConnection
    
    func description() -> NSAttributedString {
        let paragraphSyle = NSMutableParagraphStyle()
        paragraphSyle.alignment = .center
        switch self {
        case .somethingWentWrong:
            let text = NSMutableAttributedString(string: .somethingWentWrongError, attributes:
                                                    [NSAttributedString.Key.paragraphStyle : paragraphSyle,
                                                     NSAttributedString.Key.font: UIFont.customFont(size: .smallFont, weight: .medium)!])
            text.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.customRed.cgColor], range: NSRange(location: 0, length: 5))
            text.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.customBalck.cgColor], range: NSRange(location: 5, length: text.length-5))
            return text
        case .worngNumberFormat:
            return NSAttributedString(string: .invalidAmountError, attributes:
                                        [NSAttributedString.Key.paragraphStyle : paragraphSyle,
                                         NSAttributedString.Key.font: UIFont.customFont(size: .smallFont, weight: .medium)!])
        case .noInternetConnection:
            return NSAttributedString(string: .noInternetConnection, attributes:
                                        [NSAttributedString.Key.paragraphStyle : paragraphSyle,
                                         NSAttributedString.Key.font: UIFont.customFont(size: .smallFont, weight: .medium)!])
            
        }
    }
}

protocol ErrorBannerManagerProtocol {
    func showErrorBanner(errorType: ErrorBannerType)
    func hideErrorBanner()
}


class ErrorBannerManager: ErrorBannerManagerProtocol {
    
    
    public static let shared = ErrorBannerManager()
    
    var isShowing = false
    
    private lazy var errorBanner: ErrorBannerView = {
        let errorBanner = ErrorBannerView()
        errorBanner.snp.makeConstraints { (make) in
            make.height.equalTo(bannerHeight)
        }
        return errorBanner
    }()
    private var timer:Timer?
    
    private let bannerHeight:CGFloat = 100.0
    
    private init() { }
    
    func showErrorBanner(errorType: ErrorBannerType) {
        errorBanner.errorType = errorType
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .seconds(seconds: 4.0)
        config.ignoreDuplicates = true
        SwiftMessages.show(config: config, view: errorBanner)
    }
    
    func hideErrorBanner() {
        SwiftMessages.hide()
    }
}
