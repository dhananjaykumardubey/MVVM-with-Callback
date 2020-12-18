//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

protocol CurrencyViewModelInput {
    
    init(with apiClient: CCAPIClient)
    
    var sourceCurrencies: [String] { get }
    
    var usdIndex: Int { get }
}

class CurrencyViewModel: CurrencyViewModelInput {
    
    // MARK: Callbacks or observers
    
    /// Callback for showing loader
    var startLoading: (() -> Void)?
    
    /// Callback for removing the loader
    var endLoading: (() -> Void)?
    
    /// Callback for showing the error message
    var showError: ((String) -> Void)?
    
    /// Callback returning selected source currency
    var selectedSourceCurrency: ((String) -> Void)?
    
    /// Callback returning exchangeRateData as datasource
    var exchangedRateData: (([[ExchangeRateData]]) -> Void)?
    
    //MARK: Private properties
    private let apiClient: APIClient?
    private lazy var currencies: [String] = []
    private var amount: Double = 1.0
    private var selectedCurrency = ""
    private var availableCurrencyIndex = 0
    private lazy var exchangeRates: [String: Double] = [:]
    
    required init(with apiClient: CCAPIClient) {
        self.apiClient = apiClient
        self.currencies = self.readAvailableCurrencies()
    }
    
    /// Source countries having a list of currency for which exchangeRate needs to be fetched
    var sourceCurrencies: [String] {
        return self.currencies
    }
    
    /// Index of `USD` currency
    /// Used this as only `USD` was available
    var usdIndex: Int {
        return self.availableCurrencyIndex
    }
    
    /// BindViewModel call to let viewmodel know that bindViewModel of viewcontroller is called and completed and properties can be observed
    func bindViewModel() {
        self.selectedSourceCurrency?(self.selectedCurrency)
    }
    
    /**
     Get exchange rates for source currency
     - parameters:
        - currency: Source currency for which exchange rate needs to be fetched
     */
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
                                // had to save the current date, as lastTimestamp coming from API is always constant value
                                try UserDefaults.standard.setObject(Date(), forKey: "lastServiceCallDate")
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
    
    /**
     Selected source country. Let viewModel know which currency was selected for fetching the exchange rates
     - parameters:
        - index: Selected currency index
     */
    func selectedCurrency(index: Int) {
        if index < self.sourceCurrencies.count, self.amount >= 1.0 {
            self.selectedCurrency = self.sourceCurrencies[index]
            self.selectedSourceCurrency?(self.selectedCurrency)
            self.getExchangeRates(for: self.selectedCurrency)
        }
    }
    
    /**
     Entered amount which needs to be converted as per the available exchange rates
     - parameters:
        - value: Amount to be converted
     */
    func amount(value: String) {
        self.amount = Double(value) ?? 0.0
        self.mapExchangeRateData()
    }
    
    // MARK: Private methods
    
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
            let lastDate = try? UserDefaults.standard.getObject(forKey: "lastServiceCallDate", castTo: Date.self),
            let quotes = rateLists.quotes
            else { return true }
        
        let timeElapsed: Int = Int(Date().timeIntervalSince(lastDate))
        
        if timeElapsed < 30 * 60 {
            print("Call is still under 30minutes")
            self.exchangeRates = quotes
            self.mapExchangeRateData()
            self.endLoading?()
            return false
        }
        UserDefaults.standard.removeData(key: self.selectedCurrency)
        return true
    }
}
