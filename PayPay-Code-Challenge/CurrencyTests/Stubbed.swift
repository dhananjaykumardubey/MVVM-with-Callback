//
//  Stubbed.swift
//  CurrencyTests
//
//  Created by Dhananjay Kumar Dubey on 18/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation
@testable import Currency

struct Stubbed {
    static let successStubbedData = Data("""
            {
            \"success\":true,
            \"terms\":\"abc\",
            \"privacy\":\"ced\",
            \"timestamp\":1608259446,
            \"source\":\"USD\",
            \"quotes\":{
            \"USDAED\":3.673196,
            \"USDAFN\":77.067424,
            \"USDALL\":100.866046,
            \"USDAMD\":523.420203
            }
            }
            """.utf8)
    
    static let noAPIKeyErrorStubbedData  = Data("""
      {
        \"success\": false,
        \"error\": {
          \"code\": 101,
          \"info\": \"You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY]\"
        }
      }
      """.utf8)
    
    static let accessRestrictedErrorStubbedData  = Data("""
      {
        \"success\": false,
        \"error\": {
          \"code\": 105,
          \"info\": \"Access Restricted - Your current Subscription Plan does not support Source Currency Switching.\"
        }
      }
      """.utf8)
}
