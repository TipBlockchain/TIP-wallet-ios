//
//  NumberFormatterExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-11-29.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    static let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.alwaysShowsDecimalSeparator = true
        currencyFormatter.currencySymbol = ""
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        return currencyFormatter
    }()
}
