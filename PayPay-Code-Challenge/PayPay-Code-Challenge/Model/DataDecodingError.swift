//
//  DataDecodingError.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

enum DecodingDataError: Error {
    case failed
    
    var errorMessage: String {
        switch self {
        case .failed:
            return "Something went wrong.\n Please try again later"
        }
    }
}

