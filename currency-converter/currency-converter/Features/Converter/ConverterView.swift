//
//  ConverterView.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import UIKit

class ConverterView: UIView {
    
    let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0.0
        stackView.distribution = .fill
        return stackView
    }()
    
    let amountContainer:UIStackView = {
        let amountContainer = UIStackView()
        amountContainer.axis = .horizontal
        amountContainer.spacing = .smallMargin
        amountContainer.distribution = .fill
        amountContainer.spacing = UIStackView.spacingUseSystem
        amountContainer.isLayoutMarginsRelativeArrangement = true
        amountContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: .margin, bottom: 0, trailing: .margin)
        return amountContainer
    }()
    
    let amountTF: UITextField = {
        let amountTF = UITextField()
        amountTF.textColor = .customWhite
        amountTF.keyboardType = .decimalPad
        amountTF.backgroundColor = .clear
        amountTF.borderStyle = .none
        amountTF.textAlignment = .right
        amountTF.font = UIFont.customFont(size: .meduinFont, weight: .bold)
        amountTF.setContentHuggingPriority(.defaultLow, for: .horizontal)
        amountTF.snp.makeConstraints { $0.height.equalTo(70.0) }
        return amountTF
    }()
    
    let amountCurrencyLabel: UILabel = {
        let amountCurrencyLabel = UILabel()
        amountCurrencyLabel.textColor = .customWhite
        amountCurrencyLabel.backgroundColor = .clear
        amountCurrencyLabel.textAlignment = .right
        amountCurrencyLabel.font = UIFont.customFont(size: .meduinFont, weight: .bold)
        amountCurrencyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return amountCurrencyLabel
    }()
    
    let separatorLine:UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = .customBlue
        separatorLine.snp.makeConstraints { $0.height.equalTo(2.0) }
        return separatorLine
    }()
    
    let resultContainer:UIStackView = {
        let resultContainer = UIStackView()
        resultContainer.axis = .horizontal
        resultContainer.distribution = .fill
        resultContainer.spacing = UIStackView.spacingUseSystem
        resultContainer.isLayoutMarginsRelativeArrangement = true
        resultContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: .margin, bottom: 0, trailing: .margin)
        return resultContainer
    }()
    
    
    let resultLabel: UILabel = {
        let resultLabel = UILabel()
        resultLabel.textColor = .customWhite
        resultLabel.backgroundColor = .clear
        resultLabel.textAlignment = .right
        resultLabel.font = UIFont.customFont(size: .meduinFont, weight: .bold)
        resultLabel.snp.makeConstraints { $0.height.equalTo(70.0) }
        resultLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return resultLabel
    }()
    
    let resultCurrencyLabel: UILabel = {
        let resultCurrencyLabel = UILabel()
        resultCurrencyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        resultCurrencyLabel.textColor = .customWhite
        resultCurrencyLabel.backgroundColor = .clear
        resultCurrencyLabel.textAlignment = .right
        resultCurrencyLabel.font = UIFont.customFont(size: .meduinFont, weight: .bold)
        return resultCurrencyLabel
    }()
    
    func setupView() {
        
        
        addSubview(stackView)
        stackView.addArrangedSubview(amountContainer)
        stackView.addArrangedSubview(separatorLine)
        stackView.addArrangedSubview(resultContainer)
        
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(90.0)
            make.height.equalTo(142.0)
        }
        amountContainer.addArrangedSubview(amountTF)
        amountContainer.addArrangedSubview(amountCurrencyLabel)
        
        resultContainer.addArrangedSubview(resultLabel)
        resultContainer.addArrangedSubview(resultCurrencyLabel)

    }
    
    func applyGradient() {
        setGradientBackground(topColor: UIColor.customBlue, bottomColor: UIColor.darkBlue)
    }
    
}
