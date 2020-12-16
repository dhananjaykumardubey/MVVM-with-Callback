//
//  Countries.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

struct Countries: Decodable {
    public var countries: [Country]
}

struct Country: Decodable {
    let code: String?
    let name: String?
    let flag: String?
}

extension Country {
    
    private enum CodingKeys: String, CodingKey {
        
        case code = "code", name = "name", flag = "flag"
    }
    
    public init() {
        self.code = ""
        self.name = ""
        self.flag = ""
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try values.decodeIfPresent(String.self, forKey: .code)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.flag = try values.decodeIfPresent(String.self, forKey: .flag)
    }
}
