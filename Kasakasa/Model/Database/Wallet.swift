//
//  Wallet.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-19.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt
import GRDB

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

extension Wallet: TableRecord {
    public static var databaseTableName: String {
        return "wallets"
    }
}

extension Wallet: FetchableRecord, MutablePersistableRecord {

    enum Columns: String, ColumnExpression {
        case address, filePath, created, balance, currency, isPrimary, blockNumber, startBlockNumber, lastSynced
    }

    public init(row: Row) {
        self.address = row[Columns.address]
        self.filePath = row[Columns.filePath]
        self.created = row[Columns.created]
        self.balance = BigInt(row[Columns.balance] as? String ?? "0", radix: 10)!
        self.currency = Currency.init(rawValue: row[Columns.currency] as? String ?? "TIP")!
        self.isPrimary = row[Columns.isPrimary]
        self.blockNumber = BigInt(row[Columns.blockNumber] as? String ?? "0", radix: 10)!
        self.startBlockNumber = BigInt(row[Columns.startBlockNumber] as? String ?? "0", radix: 10)!
        self.lastSynced = row[Columns.lastSynced]
    }

    public func encode(to container: inout PersistenceContainer) {
        container[Columns.address.rawValue] = address
        container[Columns.filePath.rawValue] = filePath
        container[Columns.created.rawValue] = created
        container[Columns.balance.rawValue] = String(balance)
        container[Columns.currency.rawValue] = currency.rawValue
        container[Columns.isPrimary.rawValue] = isPrimary
        container[Columns.blockNumber.rawValue] = String(blockNumber)
        container[Columns.startBlockNumber.rawValue] = String(startBlockNumber)
        container[Columns.lastSynced.rawValue] = lastSynced
    }
}
