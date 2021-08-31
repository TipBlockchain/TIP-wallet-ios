//
//  StringExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-06.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(withParams arguments: [CVarArg]) -> String {
        let localizedString = self.localized
        return String(format: localizedString, arguments: arguments)
    }

    func containsSpace() -> Bool {
        return self.contains(" ")
    }

    func isUsername() -> Bool {
        let regex = "\\w{2,32}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }

    func isNumeric() -> Bool {
        let regex = "^[0-9]+(\\.)?[0-9]*$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }

    func isValidPassword() -> Bool {
        let passwordRegex = "\\w{8,255}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    func withHexPrefix() -> String {
        if !self.hasPrefix("0x") {
            return "0x" + self
        }
        return self
    }

    func withAtPrefix() -> String {
        if !self.hasPrefix("@") {
            return "@" + self
        }
        return self
    }

    private static func isChecksumAddress(str: String) -> Bool {
        return false
    }
}
