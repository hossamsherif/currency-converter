//
//  ToolBarPicker.swift
//  currency-converter
//
//  Created by Hossam Sherif on 4/8/21.
//

import UIKit

protocol ToolBarPickerDelegate: class {
    func doneAction()
    func cancelAction()
}

class ToolBarPickerController: UIViewController {
    
    weak var delegate: ToolBarPickerDelegate?
    
    var picker = UIPickerView()
    var toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupToolBar()
        view.addSubview(toolBar)
        view.addSubview(picker)
        
        
        picker.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
        picker.backgroundColor = .customWhite
        
        toolBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(picker.snp.top)
            make.height.equalTo(44.0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelAction))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupToolBar() {
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelBtn, spacer, doneBtn]
        toolBar.backgroundColor = UIColor.lightGray
    }
    
    @objc
    private func doneAction() {
        delegate?.doneAction()
    }
    
    @objc
    private func cancelAction() {
        delegate?.cancelAction()
    }

}


