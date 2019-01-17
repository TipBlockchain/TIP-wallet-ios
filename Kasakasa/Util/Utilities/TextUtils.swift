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
        return false
    }

    private static func isChecksumAddress(str: String) -> Bool {
        return false
    }
}
