//
//  currencyConverterMainView.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import Foundation
import UIKit
import SnapKit

class CurrencyConverterMainView: UIView {
    
    private let headerHeight = 250.0
    
    let header:UIView = {
        let header = UIView()
        header.isUserInteractionEnabled = true
        return header
    }()
    
    let refreshControl = UIRefreshControl()
    
    private let flagIconLableSize: CGFloat = 140.0
    
    lazy var currentCurrencyIconLabel:FlagIconLabel = {
        let currentCurrencyIcon = FlagIconLabel(frame: CGRect(x: 0, y: 0, width: 80.0, height: 80.0))
        currentCurrencyIcon.label.textAlignment = .center
        currentCurrencyIcon.label.font = UIFont.customFont(size: flagIconLableSize, weight: .bold)
        currentCurrencyIcon.label.backgroundColor = .clear
        currentCurrencyIcon.applyRoundedCorner()
        return currentCurrencyIcon
    }()
    
    let currentCurrencyLabel:UILabel = {
        let currentCurrencyLabel = UILabel()
        currentCurrencyLabel.textColor = .customWhite
        currentCurrencyLabel.textAlignment = .center
        currentCurrencyLabel.font = UIFont.customFont(size: .regularFont, weight: .medium)
        return currentCurrencyLabel
    }()
    
    let tableView:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "\(CurrencyCell.self)")
        return tableView
    }()
    
    
    func setupView() {
        backgroundColor = .customWhite
        
        addSubview(header)
        addSubview(tableView)
        
        header.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom).offset(-CGFloat.bigMargin)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        
        header.addSubviews(currentCurrencyIconLabel, currentCurrencyLabel)
        
        currentCurrencyIconLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(80.0)
            make.height.equalTo(80.0)
            make.top.equalToSuperview().offset(2*CGFloat.bigMargin)
        }
        
        currentCurrencyLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(currentCurrencyIconLabel.snp.bottom).offset(CGFloat.smallMargin)
        }
        
        tableView.refreshControl = refreshControl
    }
    
    func applyHeaderGradient() {
        header.setGradientBackground(topColor: .customBlue, bottomColor: .darkBlue)
    }
}
