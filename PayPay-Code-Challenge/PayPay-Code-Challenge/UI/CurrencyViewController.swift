//
//  CurrencyViewController.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import UIKit

final class CurrencyViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        }
    }
    
    @IBOutlet private weak var topView: UIView! {
        didSet {
            self.topView.layer.cornerRadius = CGFloat(8.0)
            self.topView.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var bottomView: UIView! {
        didSet {
            self.bottomView.layer.cornerRadius = CGFloat(8.0)
            self.bottomView.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var sourceCurrencyTextField: UITextField! {
        didSet {
            self.sourceCurrencyTextField.placeholder = "Choose Currency"
            self.sourceCurrencyTextField.borderStyle = .roundedRect
            self.sourceCurrencyTextField.layer.borderWidth = CGFloat(1.0)
            self.sourceCurrencyTextField.layer.cornerRadius = CGFloat(8.0)
            self.sourceCurrencyTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
            self.sourceCurrencyTextField.rightViewMode = .always
            self.sourceCurrencyTextField.setupRightImage(imageName: "downArrow")
        }
    }
    
    @IBOutlet private weak var amountTextField: UITextField! {
        didSet {
            self.amountTextField.placeholder = "Amount"
            self.amountTextField.borderStyle = .roundedRect
            self.amountTextField.layer.borderWidth = CGFloat(1.0)
            self.amountTextField.layer.cornerRadius = CGFloat(8.0)
            self.amountTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
            self.amountTextField.addDoneButton()
        }
    }
    
    private let viewModel = CurrencyViewModel()
    private let loadingManager = LoadingViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency"
        
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        self.viewModel.getExchangeRates(for: "INR")
        
        self.viewModel.startLoading = { [weak self] in
            guard let _self = self else { return }
            _self.loadingManager.showLoading(superView: _self.view)
        }
        
        self.viewModel.endLoading = { [weak self] in
            guard let _self = self else { return }
            _self.loadingManager.removeLoading()
        }
        
        self.viewModel.showError = { [weak self] message in
            guard let _self = self else { return }
            _self.loadingManager.showError(superView: _self.view, message: message)
        }
    }
    
    
}

