//
//  CurrencyCell.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/7/21.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    var viewModel: CurrencyCellVMProtocol! {
        didSet {
            bindVM()
        }
    }
    
    let container: UIView = {
        let container = UIView()
        container.backgroundColor = .customWhite
        container.dropShadow()
        container.layer.cornerRadius = 8.0
        return container
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = .smallMargin
        stackView.distribution = .fill
        return stackView
    }()
    
    let currencyIconLabel: FlagIconLabel = {
        let currencyIconLabel = FlagIconLabel(frame: CGRect(x: 0, y: 0, width: 35.0, height: 35.0))
        currencyIconLabel.label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        currencyIconLabel.label.font = UIFont.customFont(size: .largeFont, weight: .bold)
        currencyIconLabel.snp.makeConstraints { (make) in
            make.height.width.equalTo(35.0)
        }
        
        return currencyIconLabel
    }()
    
    let currencyTitleLabel: UILabel = {
        let currencyTitleLabel = UILabel()
        currencyTitleLabel.font = UIFont.customFont(size: .regularFont, weight: .regular)
        currencyTitleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(28.0)
        }
        currencyTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return currencyTitleLabel
    }()
    
    let currencyRateLabel: UILabel = {
        let currencyRateLabel = UILabel()
        currencyRateLabel.font = UIFont.customFont(size: .smallFont, weight: .regular)
        currencyRateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return currencyRateLabel
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(CGFloat.smallMargin)
            make.bottom.equalToSuperview().offset(-CGFloat.smallMargin)
            make.leading.equalToSuperview().offset(CGFloat.margin)
            make.trailing.equalToSuperview().offset(-CGFloat.margin)
        }
        
        container.addSubviews(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(CGFloat.margin)
            make.bottom.trailing.equalToSuperview().offset(-CGFloat.margin)
        }
        
        stackView.addArrangedSubview(currencyIconLabel)
        stackView.addArrangedSubview(currencyTitleLabel)
        stackView.addArrangedSubview(currencyRateLabel)
        currencyIconLabel.applyRoundedCorner()
    }
    
    
    func bindVM() {
        currencyTitleLabel.text = viewModel.title
        currencyIconLabel.label.text = viewModel.icon
        currencyRateLabel.text = "\(viewModel.rateValue)"
        layoutIfNeeded()

    }
    
}


