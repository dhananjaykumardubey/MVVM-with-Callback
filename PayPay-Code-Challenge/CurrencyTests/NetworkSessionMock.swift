//
//  NetworkSessionMock.swift
//  CurrencyTests
//
//  Created by Dhananjay Kumar Dubey on 18/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

@testable import Currency

class NetworkSessionMock: NetworkSession {
    enum  NetworkSessionMockError: Error {
        case responseIsNotSet
    }
    var request: URLRequestConvertible?
    var url: URL?
    var response: Result<Data>?
    
    func call(_ request: URLRequestConvertible, then completionHandler: @escaping ((Result<Data>) -> Void)) {
        
        do {
            self.request = request
            self.url = try request.expressAsURLRequest().url
            guard let response = self.response else {
                completionHandler(.failed(NetworkSessionMockError.responseIsNotSet))
                return
            }
            completionHandler(response)
        } catch {
            completionHandler(.failed(error))
        }
        
    }
}
