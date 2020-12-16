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
    let code: String
    let name: String
   // let flag: String
}
