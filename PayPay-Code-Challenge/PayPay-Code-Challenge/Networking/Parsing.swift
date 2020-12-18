//
//  Parsing.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

/**
 Parse the data into required model
 - parameters:
    - toType: Model type in which data needs to be parsed
    - data: Api response data to be parsed in Model
    - return: Parsed API response data into Model
 */
func parse<T: Decodable>(toType: T.Type, data: Data) throws -> T {
    return try JSONDecoder().decode(T.self, from: data)
}
