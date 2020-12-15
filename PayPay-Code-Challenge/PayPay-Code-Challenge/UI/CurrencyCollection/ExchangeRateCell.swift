//
//  ExchangeRateCell.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 15/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import UIKit

final class ExchangeRateCell: UICollectionViewCell {
    
    @IBOutlet private weak var mainView: UIView! {
        didSet {
            self.mainView.layer.borderWidth = CGFloat(1.0)
            self.mainView.layer.cornerRadius = CGFloat(8.0)
            self.mainView.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
            self.mainView.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var flagLabel: UILabel! {
        didSet {
            self.flagLabel.textAlignment = .center
        }
    }
    
    @IBOutlet private weak var currencyNameLabel: UILabel! {
        didSet {
            self.currencyNameLabel.textAlignment = .center
        }
    }
    
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.textAlignment = .center
        }
    }
    
    func configure(with data: ExchangeRateData) {
        /// Amount should not be rounded of 2 decimal places and should be exact value. For easy UI, handling it here
        self.amountLabel.text = Format.formattedTwoDigitDecimal(data.amount)
        
        self.flagLabel.text = data.flag
        self.currencyNameLabel.text = data.currency
        self.layoutIfNeeded()
    }
}


