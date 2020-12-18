//
//  CurrencyViewModelTests.swift
//  CurrencyTests
//
//  Created by Dhananjay Kumar Dubey on 18/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import XCTest
@testable import Currency

class CurrencyViewModelMock: CurrencyViewModelInput {
    required init(with apiClient: CCAPIClient) {
        
    }
    
    var sourceCurrencies: [String] {
        return ["abc", "ced"]
    }
    
    var usdIndex: Int {
        return 5
    }
    
    
    
}

class CurrencyViewModelTests: XCTestCase {

    private var viewModel: CurrencyViewModelMock?
    
    override func setUp() {
//        let apiclient = CCAPIClient(baseURL: URL(string: "https://abc/")!, key: "dummyKey")
//        self.viewModel = CurrencyViewModelMock(with: apiclient)
    }

    override func tearDown() {
        self.viewModel = nil
    }
    
    func testSourceCurrencies() {
        XCTAssertNotNil(self.viewModel?.sourceCurrencies)
        XCTAssertEqual(self.viewModel?.sourceCurrencies.first, "AED")
        XCTAssertEqual(self.viewModel?.sourceCurrencies.last, "ZWL")
        XCTAssertEqual(self.viewModel?.sourceCurrencies.count, 169)
    }

    func testUSDIndex() {
//        XCTAssertEqual(self.viewModel?.usdIndex, )
    }
}
