//
//  CurrencyViewController.swift
//  Currency
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import UIKit

final class CurrencyViewController: UIViewController {
    
    // MARK: Private Outlets
    
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
            self.sourceCurrencyTextField.textColor = UIColor.orange
            self.sourceCurrencyTextField.placeholder = "Choose Currency"
            self.sourceCurrencyTextField.borderStyle = .roundedRect
            self.sourceCurrencyTextField.layer.borderWidth = CGFloat(1.0)
            self.sourceCurrencyTextField.layer.cornerRadius = CGFloat(8.0)
            self.sourceCurrencyTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
            self.sourceCurrencyTextField.rightViewMode = .always
            self.sourceCurrencyTextField.setupRightImage(imageName: "downArrow")
            self.sourceCurrencyTextField.addDoneButton()
            self.sourceCurrencyTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var amountTextField: UITextField! {
        didSet {
            self.amountTextField.text = "1.0"
            self.amountTextField.borderStyle = .roundedRect
            self.amountTextField.layer.borderWidth = CGFloat(1.0)
            self.amountTextField.layer.cornerRadius = CGFloat(8.0)
            self.amountTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
            self.amountTextField.addDoneButton()
            self.amountTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.delegate = self
        }
    }
    
    // MARK: Private properties
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private lazy var currencyPickerView = UIPickerView()
    private let viewModel = CurrencyViewModel()
    private let loadingManager = LoadingViewManager()
    private var dataSource: ExchangeRateDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency"
        self.sourceCurrencyTextField.inputView = self.currencyPickerView
        self.currencyPickerView.delegate = self
        self.currencyPickerView.selectRow(self.viewModel.usdIndex, inComponent: 0, animated: true)
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        
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
            _self.loadingManager.showError(superView: _self.bottomView, message: message)
        }
        
        self.viewModel.selectedSourceCurrency = { [weak self] currency in
            guard let _self = self else { return }
            _self.sourceCurrencyTextField.text = currency
        }
        
        self.viewModel.exchangedRateData = { [weak self] data in
            guard let _self = self else { return }
            _self.dataSource = ExchangeRateDataSource(with: data)
            _self.collectionView.dataSource = _self.dataSource
            _self.collectionView.reloadData()
        }
        
        self.viewModel.selectedCurrency(index: self.currencyPickerView.selectedRow(inComponent: 0))
        self.viewModel.bindViewModel()
    }
}

// MARK: TextField delegate

extension CurrencyViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.sourceCurrencyTextField {
            self.viewModel.selectedCurrency(index: self.currencyPickerView.selectedRow(inComponent: 0))
        } else if textField == self.amountTextField {
            self.viewModel.amount(value: textField.text ?? "0.0")
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: PickerView delegate and datasource

extension CurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.sourceCurrencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row < self.viewModel.sourceCurrencies.count {
            return self.viewModel.sourceCurrencies[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if row < self.viewModel.sourceCurrencies.count {
            let titleData = self.viewModel.sourceCurrencies[row]
            let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.orange : UIColor.black
            
            let title = NSAttributedString(
                string: titleData,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0),
                             NSAttributedString.Key.foregroundColor: color])
            
            return title
        }
        return nil
    }
}

// MARK: `UICollectionViewDelegateFlowLayout` delegate methods

extension CurrencyViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (3 + 1)
        let availableWidth = self.bottomView.frame.width - paddingSpace
        let widthPerItem = availableWidth / 3

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
