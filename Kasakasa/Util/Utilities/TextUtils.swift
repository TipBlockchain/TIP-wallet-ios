//
//  TextUtils.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class TextUtils {

    static func isEmpty(_ str: String?) -> Bool {
        return str == nil || str!.isEmpty
    }

    static func containsSpace(_ str: String?) -> Bool {
        return str != nil && str!.contains(" ")
    }

    static func isUsername(_ str: String?) -> Bool {
        return false
    }

    static func isEthAddress(_ str: String?) -> Bool {
        return false
    }

    static func isNumeric(_ str: String) -> Bool {
        let regex = "^[0-9]+(\\.)?[0-9]*$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }

    static func isValidPassword(_ str: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: str)
    }

    private static func isChecksumAddress(str: String) -> Bool {
        return false
    }
}
