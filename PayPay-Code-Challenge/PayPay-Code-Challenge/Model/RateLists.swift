//
//  RateLists.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

/// Data model which will hold the parsed data of exchanged rates
struct RateLists {
    
    /// Shows whether successfully fetched or not
    let success: Bool
    
    /// terms and conditions
    let terms: String?
    
    /// returns privacy policy
    let privacy: String?
    
    /// Source against which rate was queried
    let source: String?
    
    /// Rate listt values having key as source & Destination , value as exchange rate
    let quotes: [String: Double]?
    
    /// API error
    let error: APIError?
}

extension RateLists: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        
        case success = "success", terms = "terms", privacy = "privacy", source = "source", quotes = "quotes", error = "error"
        
    }

    public init() {
        self.success = false
        self.terms = nil
        self.privacy = nil
        self.source = nil
        self.quotes = [:]
        self.error = nil
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try values.decode(Bool.self, forKey: .success)
        self.terms = try values.decodeIfPresent(String.self, forKey: .terms)
        self.privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
        self.source = try values.decodeIfPresent(String.self, forKey: .source)
        self.quotes = try values.decodeIfPresent([String: Double].self, forKey: .quotes)
        self.error = try values.decodeIfPresent(APIError.self, forKey: .error)
    }
}

struct APIError: Decodable {
    let code: Int
    let info: String
}
