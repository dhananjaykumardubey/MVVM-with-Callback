//
//  CCAPIClientForRateListRequestTests.swift
//  CurrencyTest
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
    
    
}
