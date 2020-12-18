//
//  ExchangeRateDataSource.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 15/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import UIKit

class ExchangeRateDataSource: NSObject, UICollectionViewDataSource {
    
    private var data: [[ExchangeRateData]]
    
    /**
     Initializes `ExchangeRateDataSource` with provided exchange rate data, to be displayed in collection view
     
     - parameters:
     - data: datasource of exchange rate data
     */
    init(with data: [[ExchangeRateData]]) {
        self.data = data
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as? ExchangeRateCell
            else { return UICollectionViewCell() }
        cell.configure(with: self.data[indexPath.section][indexPath.row])
        return cell
    }
}
