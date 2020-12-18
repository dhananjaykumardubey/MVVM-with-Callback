//
//  Result.swift
//  Currency
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

/**
 Used to represent state of an operation or process.
 
 - success: The operation is successful and has provided associated value.
  - failed: The operation has failed and has resulted in error.
 */

enum Result<Value> {
    
    case success(Value)
    case failed(Error)
    
    var value: Value? {
        switch self {
        case .success(let successValue):
            return successValue
        default:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .failed(let errorValue):
            return errorValue
        default:
            return nil
        }
    }
}

extension Result: Equatable where Value: Equatable {
    static func == (lhs: Result<Value>, rhs: Result<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue
            
        case (.failed(let lhsError), .failed(let rhsError)):
            return ((lhsError as NSError).isEqual((rhsError as NSError)))
            
        default:
            return false
        }
        
    }
}

