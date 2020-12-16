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
    private var availableCurrencyIndex = 0
    private lazy var exchangeRates: [String: Double] = [:]
    
    init() {
        self.apiClient = CCAPIClient(baseURL: NetworkConstant.baseURL,
                                     key: NetworkConstant.apiKey)
        self.currencies = self.readAvailableCurrencies()
    }
    
    var sourceCurrencies: [String] {
        return self.currencies
    }
    
    var usdIndex: Int {
        return self.availableCurrencyIndex
    }
    
    func bindViewModel() {
        self.selectedSourceCurrency?(self.selectedCurrency)
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
                            _self.endLoading?()
                            _self.exchangeRates = quotes
                            do {
                                try UserDefaults.standard.setObject(lists, forKey: currency)
                            } catch {
                                print("Failed to save \(error)")
                            }
                            _self.mapExchangeRateData()
                        } else {
                            _self.showError?(lists.error?.info ?? "")
                        }
                    case let .failed(error):
                        _self.showError?(error.localizedDescription)
                    }
                }
            })
        } else {
            self.endLoading?()
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
        
        guard let url = Bundle.main.url(forResource: "Countries", withExtension: "json")
            else { return [] }
        do {
            let jsonData = try Data(contentsOf: url)
            let responseData = try JSONDecoder().decode(Countries.self, from: jsonData)
            return responseData.countries.enumerated().compactMap ({ [weak self] (index, element) in
                if element.code == "USD" {
                    self?.availableCurrencyIndex = index
                }
                return element.code
            })
        }
        catch {
            print(error)
        }
        return []
    }
    
    private func shouldFetchExchangeRates() -> Bool {
        guard
            let rateLists = try? UserDefaults.standard.getObject(forKey: self.selectedCurrency, castTo: RateLists.self),
            let timeStamp = rateLists.timeStamp,
            let quotes = rateLists.quotes
            else { return true }
        
        let dateTimeStamp = Date.init(timeIntervalSinceNow: timeStamp)
        let timeElapsed: Int = Int(Date().timeIntervalSince(dateTimeStamp))
        
        if timeElapsed < 30 * 60 {
            self.exchangeRates = quotes
            self.mapExchangeRateData()
            self.endLoading?()
            return false
        }
        UserDefaults.standard.removeData(key: self.selectedCurrency)
        return true
    }
}
