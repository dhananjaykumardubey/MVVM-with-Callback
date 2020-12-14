//
//  NetworkSession.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

protocol NetworkSession {
    func call(_ request: URLRequestConvertible, then completionHandler: @escaping ((Result<Data>) -> Void))
}

extension URLSession: NetworkSession {
    
    private typealias DataTaskCompletionCallback = (Data?, URLResponse?, Error?) -> Void
    
    static let acceptedStatusCodes = Set(200...399)
    
    func call(_ request: URLRequestConvertible, then completionHandler: @escaping ((Result<Data>) -> Void)) {
        do {
            
            let urlRequest = try request.expressAsURLRequest()
            debugPrint(urlRequest.url!)
            let complation: DataTaskCompletionCallback = { data, response, error in
                
                if let requestError = error {
                    completionHandler(.failed(requestError))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, type(of: self).acceptedStatusCodes.contains(httpResponse.statusCode) else {
                    completionHandler(.failed(NetworkErrors.ResponseError.noDataAvailable))
                    return
                }
                
                guard let data = data else {
                    completionHandler(.failed(NetworkErrors.ResponseError.noDataAvailable))
                    return
                }
                
                completionHandler(.success(data))
            }
            self.dataTask(with: urlRequest, completionHandler: complation).resume()
            
        } catch {
            completionHandler(.failed(error))
        }
    }
}
