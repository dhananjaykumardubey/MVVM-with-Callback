//
//  Format.swift
//  Currency
//
//  Created by Dhananjay Kumar Dubey on 15/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

enum Format {
    
    /**
     Formats double value to have the number upto 2 decimal value
     - parameters:
        - value: Value which needs to be formatted
        - returns: Returns the formatted value in form of String
     */
    static func formattedTwoDigitDecimal(_ value: Double) -> String {
        let formatter = NumberFormatterConfig.cachedFormatter(
            forConfig: .defaultTwoDecimalNumberConfig)
        return formatter.string(for: value) ?? String(value)
    }
}

fileprivate struct NumberFormatterConfig {
    
    fileprivate let numberStyle: NumberFormatter.Style
    fileprivate let roundingMode: NumberFormatter.RoundingMode
    fileprivate let maximumFractionDigits: Int
    fileprivate let minimumIntegerDigits: Int
    fileprivate let generatesDecimalNumbers: Bool
    fileprivate let currencySymbol: String
    
    fileprivate func formatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = self.numberStyle
        formatter.roundingMode = self.roundingMode
        formatter.maximumFractionDigits = self.maximumFractionDigits
        formatter.minimumIntegerDigits = self.minimumIntegerDigits
        formatter.generatesDecimalNumbers = self.generatesDecimalNumbers
        formatter.currencySymbol = self.currencySymbol
        return formatter
    }
    
    fileprivate static var formatters: [NumberFormatterConfig: NumberFormatter] = [:]

    
    fileprivate static let defaultTwoDecimalNumberConfig = NumberFormatterConfig(numberStyle: .decimal,
                                                                                  roundingMode: .down,
                                                                                  maximumFractionDigits: 2,
                                                                                  minimumIntegerDigits: 1,
                                                                                  generatesDecimalNumbers: false,
                                                                                  currencySymbol: "")
    
    fileprivate static func cachedFormatter(forConfig config: NumberFormatterConfig) -> NumberFormatter {
        let formatter = self.formatters[config] ?? config.formatter()
        self.formatters[config] = formatter
        return formatter
    }
}

extension NumberFormatterConfig: Hashable {
    fileprivate func hash(into hasher: inout Hasher) {
        hasher.combine(self.numberStyle.hashValue)
        hasher.combine(self.roundingMode.hashValue)
        hasher.combine(self.maximumFractionDigits.hashValue)
        hasher.combine(self.minimumIntegerDigits.hashValue)
        hasher.combine(self.generatesDecimalNumbers.hashValue)
        hasher.combine(self.currencySymbol.hashValue)
    }
}

extension NumberFormatterConfig: Equatable {
    
    static fileprivate func == (lhs: NumberFormatterConfig, rhs: NumberFormatterConfig) -> Bool {
        return
            lhs.numberStyle == rhs.numberStyle
                && lhs.roundingMode == rhs.roundingMode
                && lhs.maximumFractionDigits == rhs.maximumFractionDigits
                && lhs.minimumIntegerDigits == rhs.minimumIntegerDigits
                && lhs.generatesDecimalNumbers == rhs.generatesDecimalNumbers
                && lhs.currencySymbol == rhs.currencySymbol
    }
}
