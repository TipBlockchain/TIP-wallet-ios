//
//  Wallet.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-19.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt

public struct Wallet: Codable {
    var address: String
    var filePath: String
    var created: Date
    var balance: BigInt
    let currency: Currency
    var isPrimary: Bool
    var blockNumber: BigInt
    var startBlockNumber: BigInt
    var lastSynced: Date

    init(address: String, filePath: String, created: Date, balance: BigInt, currency: Currency, isPrimary: Bool, blockNumber: BigInt, startBlockNumber: BigInt, lastSynced: Date) {
        self.address = address
        self.filePath = filePath
        self.created = created
        self.balance = balance
        self.currency = currency
        self.isPrimary = isPrimary
        self.blockNumber = blockNumber
        self.startBlockNumber = startBlockNumber
        self.lastSynced = lastSynced
    }
}
