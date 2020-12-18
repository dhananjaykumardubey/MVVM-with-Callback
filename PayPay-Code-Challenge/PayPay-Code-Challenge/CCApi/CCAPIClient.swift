//
//  ApiClient.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

protocol APIClient {
    
    init(baseURL: URL, key: String, networkSession: NetworkSession)
    
    func fetchListOfRecentRates(for countries: [String], source: String, then completion: @escaping (((Result<RateLists>) -> Void)))
}

/// Responsible for providing required content fetched from server.
struct CCAPIClient: APIClient {
    
    private let baseURL: URL
    private let networkSession: NetworkSession
    private let key: String
    
    /**
     Initializes `CCAPIClient` with provided URL, api_key and session
     
     - parameters:
        - baseURL: Base URL
        - key: API key which needs to be passed with request
     */
    init(baseURL: URL, key: String, networkSession: NetworkSession = URLSession(configuration: .ephemeral)) {
        self.baseURL = baseURL
        self.key = key
        self.networkSession = networkSession
    }
    
    /**
     Fetch the list of exchange rates against a source currency for required currencies
     
     - parameters:
         - countries: List of countries for which exchange rates needs to be fecthed
         - source: Source Currency for which exchange rates is required
         - completion: Completion block having rate list containing exchange rates
     */
    func fetchListOfRecentRates(for countries: [String], source: String, then completion: @escaping (((Result<RateLists>) -> Void))) {
        let request = RatesListRequest(url: self.baseURL, currencies: countries, apiKey: self.key, source: source)
        request.execute(onNetwork: self.networkSession, then: completion)
    }
}
