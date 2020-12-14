//
//  Parsing.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

func parse<T: Decodable>(toType: T.Type, data: Data) throws -> T {
    return try JSONDecoder().decode(T.self, from: data)
}
