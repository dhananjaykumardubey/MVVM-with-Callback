//
//  RateListRequest.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

// Provides rate list
struct RatesListRequest {
    
    let url: URL
    let currencies: [String]
    let apiKey: String
    let source: String
    
    /**
     Initializes `RatesListRequest` with URL, countries and api key
    
     - parameters:
        - url: Base URL
        - currencies: currencies list for which rates needs to be fetched
        - apiKey: Api key which will be passed with list request
        - source: Source ofthe currency
     */
    init(url: URL, currencies: [String], apiKey: String, source: String) {
        self.url = url
        self.currencies = currencies
        self.apiKey = apiKey
        self.source = source
    }
    
    private var currenciesList: String {
        return self.currencies.joined(separator: ",")
    }
}

extension RatesListRequest: DataRequest, ParameteredRequest {
    
    typealias Response = RateLists
    
    private enum Constants {
        
        static let source = "source"
        static let apiKey = "access_key"
        static let currencies = "currencies"
        static let formatKey = "format"
    }
    
    /**
     Provides request parameter which needs to be paased as query parameter in URL component, and used by request builder to create a complete url request
        - returns: A dictionary of request parameters
     */
    func parameter() -> [String : String] {
        return [
            Constants.source: self.source,
            Constants.apiKey: self.apiKey,
                Constants.currencies: self.currenciesList,
                Constants.formatKey: "1"]
    }
}
