//
//  RateListsTests.swift
//  CurrencyTests
//
//  Created by Dhananjay Kumar Dubey on 18/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import XCTest

@testable import Currency

class RateListsTests: XCTestCase {

    func testRateListsSuccessAndNotNill() {
        do {
            let rateLists = try JSONDecoder().decode(RateLists.self, from: Stubbed.successStubbedData)
            
            XCTAssertNotNil(rateLists)
            XCTAssertEqual(rateLists.success, true)
            XCTAssertNotNil(rateLists.terms)
            XCTAssertNotNil(rateLists.privacy)
            XCTAssertNotNil(rateLists.timeStamp)
            XCTAssertNotNil(rateLists.source)
            XCTAssertNotNil(rateLists.quotes)
            XCTAssertNil(rateLists.error)
            
            XCTAssertEqual(rateLists.terms, "abc")
            XCTAssertEqual(rateLists.privacy, "ced")
            XCTAssertEqual(rateLists.timeStamp, 1608259446)
            XCTAssertEqual(rateLists.source, "USD")
            XCTAssertEqual(rateLists.quotes, [
                "USDAED": 3.673196,
                "USDAFN": 77.067424,
                "USDALL":100.866046,
                "USDAMD":523.420203
            ])

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRateListsFailureForNoApiKey() {
        do {
            let rateLists = try JSONDecoder().decode(RateLists.self, from: Stubbed.noAPIKeyErrorStubbedData)
            
            XCTAssertNotNil(rateLists)
            XCTAssertNotNil(rateLists.error)
            XCTAssertEqual(rateLists.success, false)
            
            XCTAssertNil(rateLists.terms)
            XCTAssertNil(rateLists.privacy)
            XCTAssertNil(rateLists.timeStamp)
            XCTAssertNil(rateLists.source)
            XCTAssertNil(rateLists.quotes)
            
            XCTAssertEqual(rateLists.error?.code, 101)
            XCTAssertEqual(rateLists.error?.info, "You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY]")

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRateListsFailureForNoAccess() {
        do {
            let rateLists = try JSONDecoder().decode(RateLists.self, from: Stubbed.accessRestrictedErrorStubbedData)
            
            XCTAssertNotNil(rateLists)
            XCTAssertNotNil(rateLists.error)
            XCTAssertEqual(rateLists.success, false)
            
            XCTAssertNil(rateLists.terms)
            XCTAssertNil(rateLists.privacy)
            XCTAssertNil(rateLists.timeStamp)
            XCTAssertNil(rateLists.source)
            XCTAssertNil(rateLists.quotes)
            
            XCTAssertEqual(rateLists.error?.code, 105)
            XCTAssertEqual(rateLists.error?.info, "Access Restricted - Your current Subscription Plan does not support Source Currency Switching.")

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
