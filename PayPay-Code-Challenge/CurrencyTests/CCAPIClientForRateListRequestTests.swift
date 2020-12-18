//
//  CCAPIClientForRateListRequestTests.swift
//  CurrencyTests
//
//  Created by Dhananjay Kumar Dubey on 18/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import XCTest

@testable import Currency

class CCAPIClientForRateListRequestTests: XCTestCase {
    
    var mock: NetworkSessionMock!
    
    override func setUp() {
        self.mock = NetworkSessionMock()
    }
    
    override func tearDown() {
        self.mock = nil
    }
    
    func testExpectSuccessFullResponseWhenValidJSONIsAvailable() {
        
        let mockQuotes = [
            "USDAED": 3.673196,
            "USDAFN": 77.067424,
            "USDALL":100.866046,
            "USDAMD":523.420203
        ]
        
        self.mock.response = .success(Stubbed.successStubbedData)
        
        let client = CCAPIClient(baseURL: URL(string: "http://abc.com")!, key: "key", networkSession: self.mock)
        
        let expectation = self.expectation(description: "Expect success")
        
        let countries = ["AED", "AFN", "ALL", "AMD"]
        
        client.fetchListOfRecentRates(for: countries, source: "USD") { response in
            expectation.fulfill()
            XCTAssertNotNil(response.value)
            XCTAssertEqual(response.value?.success, true)
            XCTAssertEqual(response.value?.terms, "abc")
            XCTAssertEqual(response.value?.privacy, "ced")
            XCTAssertEqual(response.value?.source, "USD")
            XCTAssertEqual(response.value?.quotes, mockQuotes)
        }
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testRequest() {
        
        let client = CCAPIClient(baseURL: URL(string: "http://abc.com")!, key: "key", networkSession: self.mock)
        
        let expectation = self.expectation(description: "Expect success")
        
        let countries = ["abc", "ced"]
        
        client.fetchListOfRecentRates(for: countries, source: "USD") { _ in
            expectation.fulfill()
        }
        
        guard let receivedRequest = self.mock.request as? RatesListRequest else {
            XCTFail("Invalid request received expected was RatesListRequest")
            return
        }
        
        XCTAssertEqual(receivedRequest.url.absoluteString, "http://abc.com")
        XCTAssertEqual(receivedRequest.apiKey, "key")
        XCTAssertEqual(receivedRequest.currencies, ["abc", "ced"])
        XCTAssertEqual(receivedRequest.parameter(), [
                    "source": "USD",
                    "currencies": "abc,ced",
                    "access_key": "key",
                    "format": "1"
                    ])
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testExpectFailureWhenAPIkeyIsNotPresent() {
        self.mock.response = .success(Stubbed.noAPIKeyErrorStubbedData)
        
        let client = CCAPIClient(baseURL: URL(string: "http://abc.com")!, key: "", networkSession: self.mock)
        let expectation = self.expectation(description: "Expect failure")
        
        let countries = ["AED", "AFN"]
        
        client.fetchListOfRecentRates(for: countries, source: "USD") { response in
            expectation.fulfill()
            XCTAssertNotNil(response.value)
            XCTAssertEqual(response.value?.success, false)
            XCTAssertEqual(response.value?.error?.code, 101)
            XCTAssertEqual(response.value?.error?.info, "You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY]")
        }
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testExpectErrorsWhenInValidJSONSet() {
        
        self.mock.response = .success(Data())
        
        let client = CCAPIClient(baseURL: URL(string: "http://abc.com")!, key: "", networkSession: self.mock)
        let expectation = self.expectation(description: "Expect failure")
        
        let countries = ["AED", "AFN"]
        
        client.fetchListOfRecentRates(for: countries, source: "USD") { response in
            expectation.fulfill()
            XCTAssertNil(response.value)
            XCTAssertNotNil(response.error)
            XCTAssertTrue(response.error is DecodingError)
        }
        self.wait(for: [expectation], timeout: 1)
    }
}

