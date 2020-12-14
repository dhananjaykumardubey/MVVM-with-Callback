//
//  RequestBuilder.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

protocol RequestBuilder {
    func buildURLRequest(withURL baseUrl: URL, andParameters parameters: [String: String]) throws -> URLRequest
}

struct NetworkRequestBuilder: RequestBuilder {
    
    enum BuilderError: Error {
        case apiKeyMissing
        case unableToResolveURL(URL)
        case unableBuildURL(message: String)
    }
    
    func buildURLRequest(withURL baseUrl: URL, andParameters parameters: [String: String]) throws -> URLRequest {
        
        /// Putting endpoint directly for this code due to time constraint. But yes, this should be done separately to add scalability
        let url = baseUrl.appendingPathComponent("live")
        
        guard var components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false) else {
                                                throw BuilderError.unableToResolveURL(url)
        }
        var queryItems = [URLQueryItem]()
        for key in parameters.keys.sorted() {
            guard let param = parameters[key] else { continue }
            queryItems.append(URLQueryItem(name: key, value: param))
        }
        
        components.queryItems = queryItems
        
        guard let fullUrl = components.url else {
            let errorMessage = components.queryItems?.map { String(describing: $0) }.joined(separator: ", ") ?? ""
            
            throw BuilderError.unableBuildURL(message: "query item \(errorMessage)")
        }
        
        
        return URLRequest(url: fullUrl,
                          cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData,
                          timeoutInterval: 30)
    }
}
