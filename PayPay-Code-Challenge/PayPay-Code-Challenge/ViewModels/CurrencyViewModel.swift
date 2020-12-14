//
//  CurrencyViewModel.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

class CurrencyViewModel {
   
    var startLoading: (() -> Void)?
    var endLoading: (() -> Void)?
    var showError: ((String) -> Void)?
    
    private let apiClient: APIClient?
    private lazy var currencies: [String] = []
    
    init() {
        self.apiClient = CCAPIClient(baseURL: NetworkConstant.baseURL,
                                     key: NetworkConstant.apiKey)
        self.currencies = self.readAvailableCurrencies()
    }
    
    func getExchangeRates(for currency: String) {
        self.startLoading?()
        self.apiClient?.fetchListOfRecentRates(for: self.currencies, source: currency, then: { [weak self] response in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case let .success(lists):
                    if lists.success {
                        _self.endLoading?()
                    } else {
                        _self.showError?(lists.error?.info ?? "")
                    }
                case let .failed(error):
                    _self.showError?(error.localizedDescription)
                }
            }
        })
    }
    
    private func readAvailableCurrencies() -> [String] {
        
        guard
            let url =  Bundle.main.path(forResource: "Countries", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: url), options: .mappedIfSafe),
            let responseData = try? JSONDecoder().decode(Countries.self, from: data)
            else { return [] }
        
        return responseData.countries.map { $0.code }
    }
}
