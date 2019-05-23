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
//        return number.dividing(by: NSDecimalNumber(value: pow(10, unit.rawValue)))
    }

    public static func toWei(_ number: BigUInt, toUnit unit: Unit) -> NSDecimalNumber {
        let string = String(number)
        return self.toWei(NSDecimalNumber(string: string), toUnit: unit)
    }

    public static func toWei(_ number: String, toUnit unit: Unit) -> NSDecimalNumber {
        return self.toWei(NSDecimalNumber(string: number), toUnit: unit)
    }

    public static func toWei(_ number: NSDecimalNumber, toUnit unit: Unit) -> NSDecimalNumber {
        return number.multiplying(by: NSDecimalNumber(integerLiteral: unit.rawValue))
    }
}
