//
//  Request.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

protocol URLRequestConvertible {
    func expressAsURLRequest() throws -> URLRequest
}

protocol Request: URLRequestConvertible {
    var url: URL { get }
}

///Just informing that request will be parameterized
protocol ParameteredRequest: Request {
    func parameter() -> [String: String]
    func build(usingBuilder builder: RequestBuilder) throws -> URLRequest
}

extension ParameteredRequest {
    func build(usingBuilder builder: RequestBuilder = NetworkRequestBuilder()) throws -> URLRequest {
        return try builder.buildURLRequest(withURL: self.url, andParameters: self.parameter())
    }
    
    func expressAsURLRequest() throws -> URLRequest {
        return try self.build()
    }
}

protocol DataRequest: Request {
    associatedtype Response: Decodable
    func execute(onNetwork network: NetworkSession, then completion: @escaping ((Result<Response>) -> Void))
    
}

extension DataRequest {
    func execute(onNetwork network: NetworkSession, then completion: @escaping ((Result<Response>) -> Void)) {
        
        network.call(self) { result in
            
            switch result {
            case .success( let data):
                do {
                    let result = try parse(toType: Response.self, data: data)
                    completion(.success(result))
                } catch {
                    completion(.failed(error))
                }
            case .failed(let error):
                completion(.failed(error))
            }
        }
    }
}
