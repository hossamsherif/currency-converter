//
//  FlagIconLabel.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/8/21.
//

import Foundation
import UIKit

class FlagIconLabel: UIView {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyRoundedCorner() {
        layer.masksToBounds = true
        clipsToBounds = true
        layer.cornerRadius = frame.width/2
    }
    
}
