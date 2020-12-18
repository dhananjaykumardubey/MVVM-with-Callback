//
//  ExchangeRateData.swift
//  Currency
//
//  Created by Dhananjay Kumar Dubey on 15/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

struct ExchangeRateData {
    let flag: String
    let currency: String
    let amount: Double
}

extension ExchangeRateData: Equatable {
    static func ==(lhs: ExchangeRateData, rhs: ExchangeRateData) -> Bool {
        return lhs.flag == rhs.flag &&
            lhs.currency == rhs.currency &&
            lhs.amount == rhs.amount
    }
}
