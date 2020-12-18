//
//  NetworkConstant.swift
//  Currency
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

enum NetworkConstant {
    /// Base URL for fetching exchange rate
    static let baseURL = URL(string: "http://api.currencylayer.com/")!
    
    /// API key for Currency layer
    static let apiKey = "5a150f1d482c1d87535c73880ed51426"
}
