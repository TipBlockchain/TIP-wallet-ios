//
//  TextUtils.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import web3swift

public class TextUtils {

    public static func isEmpty(_ str: String?) -> Bool {
        return str == nil || str!.isEmpty
    }

    public static func containsSpace(_ str: String?) -> Bool {
        return str != nil && str!.contains(" ")
    }

    public static func isUsername(_ str: String?) -> Bool {
        let regex = "([a-zA-Z\\d-_\\.]){2,16}"

        if let str = str {
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
        }
        return false
    }

    public static func isEthAddress(_ str: String?) -> Bool {

        guard let address = str else {
            return false
        }
        let basicRegex = "^(0x|0X)?[0-9a-fA-F]{40}$"
        let allLowerCase = "^(0x)?[0-9a-f]{40}$"
        let allUpperCase = "^(0x|0X)?[0-9A-F]{40}$"

        let basicPredicate = NSPredicate(format: "SELF MATCHES %@", basicRegex)
        let allLowerPredicate = NSPredicate(format: "SELF MATCHES %@", allLowerCase)
        let allUpperPredicate = NSPredicate(format: "SELF MATCHES %@", allUpperCase)

        if (!basicPredicate.evaluate(with: address.lowercased())) { // lowercased to catch the '0X'
            // check if it has the basic requirements of an address
            return false
        } else if (allLowerPredicate.evaluate(with: address) || allUpperPredicate.evaluate(with: address)) {
            // If it's all small caps or all all caps, return true
            return true
        } else {
            // Otherwise check each case
//            return true
            return isChecksumAddress(address)
        }
    }

    private static func isChecksumAddress(_ address: String) -> Bool {
        let addressWithout0x = address.replacingOccurrences(of: "0x", with: "")
        let addressHash = Web3.Utils.sha3(addressWithout0x.lowercased().data(using: .ascii)!)!.toHexString()
        for i in addressWithout0x.indices {
            // the nth letter should be uppercase if the nth digit of casemap is 1

            if ((Int(String(addressHash[i]), radix: 16)! > 7 && addressWithout0x[i].uppercased() != String(addressWithout0x[i])) ||
                (Int(String(addressHash[i]), radix: 16)! <= 7 && addressWithout0x[i].lowercased() != String(addressWithout0x[i]))) {
                return false
            }
        }
        return true
    }

    public static func isNumeric(_ str: String) -> Bool {
        let regex = "^[0-9]+(\\.)?[0-9]*$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }

    public static func isValidPassword(_ str: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: str)
    }

}
