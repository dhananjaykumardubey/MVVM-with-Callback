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
    var selectedSourceCurrency: ((String) -> Void)?
    var exchangedRateData: (([[ExchangeRateData]]) -> Void)?
    
    private let apiClient: APIClient?
    private lazy var currencies: [String] = []
    private var amount: Double = 1.0
    private var selectedCurrency = ""
    private lazy var exchangeRates: [String: Double] = [:]
    
    init() {
        self.apiClient = CCAPIClient(baseURL: NetworkConstant.baseURL,
                                     key: NetworkConstant.apiKey)
        self.currencies = self.readAvailableCurrencies()
    }
    
    var sourceCurrencies: [String] {
        return ["USD", "INR"]
    }
    
    func bindViewModel() {
        self.selectedSourceCurrency?(self.sourceCurrencies.first ?? "USD")
    }
    
    func getExchangeRates(for currency: String) {
        self.startLoading?()
        
        if self.shouldFetchExchangeRates() {
            self.apiClient?.fetchListOfRecentRates(for: self.currencies, source: currency, then: { [weak self] response in
                guard let _self = self else { return }
                DispatchQueue.main.async {
                    switch response {
                    case let .success(lists):
                        if lists.success, let quotes = lists.quotes, !quotes.isEmpty {
                            print(lists)
                            _self.exchangeRates = quotes
                            UserDefaultsHelper.set(lists, forKey: currency)
                            _self.mapExchangeRateData()
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
    }
    
    func selectedCurrency(index: Int) {
        if index < self.sourceCurrencies.count, self.amount >= 1.0 {
            self.selectedCurrency = self.sourceCurrencies[index]
            self.selectedSourceCurrency?(self.selectedCurrency)
            self.getExchangeRates(for: self.selectedCurrency)
        }
    }
    
    func amount(value: String) {
        self.amount = Double(value) ?? 0.0
        self.mapExchangeRateData()
    }
    
    private func mapExchangeRateData() {
        var exchangeRatesData: [ExchangeRateData] = []
        for (key, value) in self.exchangeRates {
            let currency = key.dropFirst(3)
            let totalAmount = self.amount * value
            let rates = ExchangeRateData(flag: "", currency: String(currency), amount: totalAmount)
            exchangeRatesData.append(rates)
        }
        self.exchangedRateData?(exchangeRatesData.chunked(into: 3))
    }
    
    private func readAvailableCurrencies() -> [String] {
        
        guard
            let url =  Bundle.main.path(forResource: "Countries", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: url), options: .mappedIfSafe),
            let responseData = try? JSONDecoder().decode(Countries.self, from: data)
            else { return [] }
        
        return responseData.countries.map { $0.code }
    }
    
    private func shouldFetchExchangeRates() -> Bool {
        guard
            let rateLists = UserDefaultsHelper.get(forKey: self.selectedCurrency),
            let timeStamp = rateLists.timeStamp,
            let quotes = rateLists.quotes
            else { return true }
        
        let minimumMinutes = 30.0
        
        let date = Date(timeIntervalSince1970: timeStamp)
        
        if date.timeIntervalSinceNow < (30 * minimumMinutes) {
            debugPrint("Not making call, Didn't go 30 min yet")
            self.exchangeRates = quotes
            self.mapExchangeRateData()
            self.endLoading?()
            return false
        }
        UserDefaultsHelper.removeData(key: self.selectedCurrency)
        return true
    }
}
