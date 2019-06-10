//
//  Transaction.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-23.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import GRDB
import BigInt
import web3swift

public struct Transaction: Codable, DictionaryEncodable {

    var hash: String
    var blockHash: String?
    var from: String
    var to: String
    var currency: String?
    var value: BigUInt
    var timestamp: Date
    var gas: BigUInt
    var confirmations: BigUInt
    var nonce: Int?
    var message: String?
    var txReceiptStatus: String?

    var fromUser: UserStub?
    var toUser: UserStub?

    enum CodingKeys: String, CodingKey, ColumnExpression {
        case hash
        case blockHash
        case from
        case to
        case currency
        case value
        case timestamp = "timeStamp"
        case confirmations
        case gas
        case nonce
        case message
        case txReceiptStatus = "txreceipt_status"

        case fromUser
        case toUser

        case fromUserId = "fromUser_id"
        case fromUsername = "fromUser_username"
        case fromFullname = "fromUser_fullname"
        case fromPhotoUrl = "fromUser_photoUrl"

        case toUserId = "toUser_id"
        case toUsername = "toUser_username"
        case toFullname = "toUser_fullname"
        case toPhotoUrl = "toUser_photoUrl"
    }

    enum Columns: String, ColumnExpression {
        case hash, blockHash, from, to, currency, value, timestamp, confirmations, gas, nonce, message
        case txReceiptStatus = "txreceipt_status"
        case fromUserId = "fromUser_id"
        case fromUsername = "fromUser_username"
        case fromFullname = "fromUser_fullname"
        case fromPhotoUrl = "fromUser_photoUrl"

        case toUserId = "toUser_id"
        case toUsername = "toUser_username"
        case toFullname = "toUser_fullname"
        case toPhotoUrl = "toUser_photoUrl"
    }

    init(hash: String, blockHash: String, from: String, to: String, currency: String?, value: BigUInt, timestamp: Date, gas: BigUInt, confirmations: BigUInt, nonce: Int, message: String?, txReceiptStatus: String?, fromUser: UserStub?, toUser: UserStub?) {
        self.hash = hash
        self.blockHash = blockHash
        self.from = from
        self.to = to
        self.currency = currency
        self.value = value
        self.timestamp = timestamp
        self.gas = gas
        self.confirmations = confirmations
        self.nonce = nonce
        self.message = message
        self.txReceiptStatus = txReceiptStatus
        self.fromUser = fromUser
        self.toUser = toUser
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(hash, forKey: CodingKeys.hash)
        try container.encode(blockHash, forKey: CodingKeys.blockHash)
        try container.encode(from, forKey: CodingKeys.from)
        try container.encode(to, forKey: CodingKeys.to)
        try container.encode(currency, forKey: CodingKeys.currency)
        try container.encode(String(value), forKey: CodingKeys.value)
        try container.encode(timestamp, forKey: CodingKeys.timestamp)
        try container.encode(String(gas), forKey: CodingKeys.gas)
        try container.encode(String(confirmations), forKey: CodingKeys.confirmations)
        try container.encode(nonce, forKey: CodingKeys.nonce)
        try container.encode(message, forKey: CodingKeys.message)
        try container.encode(txReceiptStatus, forKey: CodingKeys.txReceiptStatus)
        try container.encode(fromUser, forKey: CodingKeys.fromUser)
        try container.encode(toUser, forKey: CodingKeys.toUser)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let hash = try container.decode(String.self, forKey: CodingKeys.hash)
        let blockHash = try container.decode(String.self, forKey: CodingKeys.blockHash)
        let from = try container.decode(String.self, forKey: CodingKeys.from)
        let to = try container.decode(String.self, forKey: CodingKeys.to)
        let currency = try? container.decode(String.self, forKey: CodingKeys.currency)

        var value = BigUInt(integerLiteral: 0)
        if let valueString = try? container.decode(String.self, forKey: CodingKeys.value), valueString.isNumeric() {
            value = BigUInt(valueString)!
        }

        let timestampStr = try? container.decode(String.self, forKey: CodingKeys.timestamp)

        var timestamp: Date? = nil
        if let timestampStr = timestampStr, let timeInterval = TimeInterval(timestampStr) {
            timestamp = Date(timeIntervalSince1970: timeInterval)
        }
        if  timestamp == nil, let timestampStr = timestampStr {
            timestamp = DateFormatter.jsonFormatter.date(from: timestampStr)
        }
        if timestamp == nil {
            timestamp = Date()
        }

        var gas = BigUInt("0")
        if let gasString = try? container.decode(String.self, forKey: CodingKeys.gas), gasString.isNumeric() {
            gas = BigUInt(gasString)!
        }

        var confirmations = BigUInt("0")
        if let confirmationsString = try? container.decode(String.self, forKey: CodingKeys.confirmations), confirmationsString.isNumeric() {
            confirmations = BigUInt(confirmationsString)!
        }
        var nonce = 0
        if let nonceStr = try? container.decode(String.self, forKey: CodingKeys.nonce), nonceStr.isNumeric() {
            nonce = Int(nonceStr)!
        }
        let message = try? container.decodeIfPresent(String.self, forKey: CodingKeys.message)
        let receiptStatus = try? container.decodeIfPresent(String.self, forKey: CodingKeys.txReceiptStatus)
        let fromUser = try? container.decode(UserStub.self, forKey: CodingKeys.fromUser)
        let toUser = try? container.decode(UserStub.self, forKey: CodingKeys.toUser)

        self.init(hash: hash, blockHash: blockHash, from: from, to: to, currency: currency, value: value, timestamp: timestamp!, gas: gas, confirmations: confirmations, nonce: nonce, message: message, txReceiptStatus: receiptStatus, fromUser: fromUser, toUser: toUser)
    }

//    public init(from pendingTx: PendingTransaction, result: TransactionSendingResult) {
//        self.init(hash: result.hash, blockHash: result.block, from: <#T##String#>, to: <#T##String#>, currency: <#T##String?#>, value: <#T##BigUInt#>, timestamp: <#T##Date#>, gas: <#T##BigUInt#>, confirmations: <#T##BigUInt#>, nonce: <#T##Int#>, message: <#T##String?#>, txReceiptStatus: <#T##String?#>, fromUser: <#T##UserStub?#>, toUser: <#T##UserStub?#>)
//    }
}

// Mark - database stuff

extension  Transaction: TableRecord {
    public static var databaseTableName: String {
        return "transactions"
    }
}

extension Transaction: FetchableRecord, MutablePersistableRecord {

    public init(row: Row) {
        let hash = row[Columns.hash] as String
        let blockHash = row[Columns.blockHash] as String
        let from = row[Columns.from] as String
        let to = row[Columns.to] as String
        let currency = row[Columns.currency] as String
        let value = BigUInt(row[Columns.value] as String, radix: 10) ?? BigUInt(integerLiteral: 0)
        let timestamp = row[Columns.timestamp] as Date //DateFormatter.sqlDateFormatter.date(from: row[Columns.timestamp] as String)!
        let gas = BigUInt(row[Columns.gas] as String) ?? BigUInt(integerLiteral: 0)
        let confirmations = BigUInt(row[Columns.confirmations] as String) ?? BigUInt(integerLiteral: 0)
        let nonce = row[Columns.nonce] as Int
        let message = row[Columns.message] as String?
        let txReceiptStatus = row[Columns.txReceiptStatus] as String?

        var fromUser: UserStub? = nil
        var toUser: UserStub? = nil

        let fromUserId = row[Columns.fromUserId] as String?
        let fromUsername = row[Columns.fromUsername] as String?
        let fromFullname = row[Columns.fromFullname] as String?
        let fromPhotoUrl = row[Columns.fromPhotoUrl] as String?
        if let fromUserId = fromUserId {
            fromUser = UserStub(id: fromUserId, username: fromUsername, fullname: fromFullname, address: from, photoUrl: fromPhotoUrl)
        }

        let toUserId = row[Columns.toUserId] as String?
        let toUsername = row[Columns.toUsername] as String?
        let toFullname = row[Columns.toFullname] as String?
        let toPhotoUrl = row[Columns.toPhotoUrl] as String?

        if let toUserId = toUserId {
            toUser = UserStub(id: toUserId, username: toUsername, fullname: toFullname, address: to, photoUrl: toPhotoUrl)
        }

        self.init(hash: hash, blockHash: blockHash, from: from, to: to, currency: currency, value: value, timestamp: timestamp, gas: gas, confirmations: confirmations, nonce: nonce, message: message, txReceiptStatus: txReceiptStatus, fromUser: fromUser, toUser: toUser)
    }

    public func encode(to container: inout PersistenceContainer) {
        container[CodingKeys.hash] = hash
        container[Columns.blockHash] = blockHash
        container[Columns.from] = from
        container[Columns.to] = to
        container[Columns.currency] = currency
        container[Columns.value] = String(value)
        container[Columns.timestamp] = timestamp
        container[Columns.gas] = String(gas)
        container[Columns.confirmations] = String(confirmations)
        container[Columns.nonce] = nonce
        container[Columns.message] = message
        container[Columns.txReceiptStatus] = txReceiptStatus
        container[Columns.fromUserId] = fromUser?.id
        container[Columns.fromUsername] = fromUser?.username
        container[Columns.fromFullname] = fromUser?.fullname
        container[Columns.fromPhotoUrl] = fromUser?.photoUrl
        container[Columns.toUserId] = toUser?.id
        container[Columns.toUsername] = toUser?.username
        container[Columns.toFullname] = toUser?.fullname
        container[Columns.toPhotoUrl] = toUser?.photoUrl
    }
}

extension Transaction {

    static func orderedByDate() -> QueryInterfaceRequest<Transaction> {
        return Transaction.order(CodingKeys.timestamp)
    }

    static func forCurrency(_ currency: Currency) -> QueryInterfaceRequest<Transaction> {
        return Transaction.filter(sql: "currency = ?", arguments: [currency.rawValue])
    }
}

extension Transaction: Equatable {
    public static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.hash == rhs.hash &&
            lhs.blockHash == rhs.blockHash &&
            lhs.from == rhs.from &&
            lhs.to == rhs.to &&
            lhs.value == rhs.value &&
            lhs.nonce == rhs.nonce &&
            lhs.timestamp == rhs.timestamp
    }

}
