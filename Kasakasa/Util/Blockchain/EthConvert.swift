//
//  EthConvert.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-25.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import web3swift
import BigInt

class EthConvert {

    private init() {}

    public enum Unit: Int {
        case wei = 0
        case kwei = 3
        case mwei = 6
        case gwei = 9
        case szabo = 12
        case finney = 15
        case ether = 18
        case kether = 21
        case mether = 24
        case gether = 27

        var description: String {
            return ""
        }

        private var name: String? {
            return self.description
        }
    }

    public static func fromWei(_ number: BigUInt, toUnit unit: Unit) -> NSDecimalNumber {
        let string = String(number)
        return self.fromWei(NSDecimalNumber(string: string), toUnit: unit)
    }

    public static func fromWei(_ number: String, toUnit unit: Unit) -> NSDecimalNumber {
        return self.fromWei(NSDecimalNumber(string: number), toUnit: unit)
    }

    public static func fromWei(_ number: NSDecimalNumber, toUnit unit: Unit) -> NSDecimalNumber {
        return number.multiplying(byPowerOf10: Int16(unit.rawValue) * -1)
    }

    public static func toWei(_ number: BigUInt, fromUnit unit: Unit) -> BigUInt? {
        return number * BigUInt("10").power(unit.rawValue)
    }

    public static func toWei(_ number: String, fromUnit unit: Unit) -> BigUInt? {
        if let numberAsBigUInt = BigUInt(number) {
            return self.toWei(numberAsBigUInt, fromUnit: unit)
        }
        return nil
    }

    public static func toWei(_ number: NSDecimalNumber) -> BigUInt? {
        return toUnit(number, toUnit: .wei)
    }

    public static func toUnit(_ number: NSDecimalNumber, toUnit unit: Unit) -> BigUInt? {
        return Web3.Utils.parseToBigUInt(number.description(withLocale: Locale.current), units: .eth)
    }

    public static func toEthereumUnits(_ bigUIntValue: BigUInt, decimals: Int = 4) -> String? {
        return Web3.Utils.formatToEthereumUnits(bigUIntValue, toUnits: .eth, decimals: decimals)
    }
}
