//
//  Array+Chunk.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 15/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

extension Array where Element == ExchangeRateData {
    
    /**
     Chunks an array in required size. Can be used to convert 1D array into 2D array of required size
     - parameters:
        - size: Size in which 1D array needs to be chunked
        - returns: Returns 2D array with each array of required size
     */
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
