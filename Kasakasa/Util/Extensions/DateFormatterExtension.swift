//
//  DateFormatterExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

extension DateFormatter {

    static let defaultFormatter: DateFormatter = {
        let dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.dateFormat = dateFormat
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let keystoreFileDateFormatter: DateFormatter = {
        let dateFormat = "YYYY-MM-dd'T'hh-mm-ss'Z'"
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
