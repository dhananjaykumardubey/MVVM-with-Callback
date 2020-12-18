//
//  CurrencyViewModelTests.swift
//  CurrencyTests
//
//  Created by Dhananjay Kumar Dubey on 18/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import XCTest
@testable import Currency

class CurrencyViewModelTests: XCTestCase {

    private var viewModel: CurrencyViewModel?
    private var mock: NetworkSessionMock!
    
    override func setUp() {
        self.mock = NetworkSessionMock()
        self.viewModel = CurrencyViewModel(with: CCAPIClient(baseURL: URL(string: "https://abc/")!, key: "dummyKey", networkSession: self.mock))
    }

    override func tearDown() {
        self.viewModel = nil
        self.mock = nil
    }
    
    func testSourceCurrencies() {
        XCTAssertNotNil(self.viewModel?.sourceCurrencies)
        XCTAssertEqual(self.viewModel?.sourceCurrencies.first, "AED")
        XCTAssertEqual(self.viewModel?.sourceCurrencies.last, "ZWL")
        XCTAssertEqual(self.viewModel?.sourceCurrencies.count, 169)
    }

    func testUSDIndex() {
        XCTAssertEqual(self.viewModel?.usdIndex, 150)
    }
    
    func testFetchingExchangeRate() {
        self.mock.response = .success(Stubbed.successStubbedData)
        let expectation = self.expectation(description: "Expect success")
        
        self.viewModel?.getExchangeRates(for: "USD")
        self.viewModel?.exchangedRateData = { data in
            expectation.fulfill()
            XCTAssertNotNil(data)
            XCTAssertEqual(data.count, 2)
        }
        self.wait(for: [expectation], timeout: 1)
    }
}
