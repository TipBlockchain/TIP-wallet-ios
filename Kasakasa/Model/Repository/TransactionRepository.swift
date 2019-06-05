//
//  TransactionRepository.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-23.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt
import web3swift

typealias TransactionListClosure = (([Transaction]?, AppErrors?) -> Void)
typealias TransactionSendClosure = ((TransactionSendingResult?, AppErrors?) -> Void)

class TransactionRepository {

    static var shared = TransactionRepository()
    var dbPool = AppDatabase.dbPool
    lazy var web3Bridge = Web3Bridge.shared

    var ethApi = EtherscanApiService.shared
    var tipApi = TipApiService.sharedInstance

    func sendTransaction(_ transaction: PendingTransaction, withPassword password: String, gasPrice: BigUInt, completion: @escaping TransactionSendClosure) {
        var result: TransactionSendingResult? = nil
        do {
            switch transaction.currency {
            case .ETH:
                result = try web3Bridge.sendEthTransaction(value: transaction.value, fromAddress: transaction.from, toAddress: transaction.to, withPassword: password, gasPrice: gasPrice)
            case .TIP:
                result = try web3Bridge.sendERC20Transaction(value: transaction.value, from: transaction.from, toAddress: transaction.to, withPassword: password, token: TipProcessor.tipToken)
            }
            // TODO: Insert new tx in db here
            completion(result, nil)
        } catch  {
            completion(nil, AppErrors.error(error: error))
        }
    }

    func allTransactions() throws -> [Transaction]? {
        return try dbPool?.read({ (db)  in
            return try Transaction.fetchAll(db)
        })
    }

    func transactions(forCurrency currency: Currency) throws -> [Transaction] {
        return try dbPool!.read({ db -> [Transaction]? in
            return try Transaction.fetchAll(db, "SELECT * from transactions where currency = ?", arguments: [currency.rawValue])
        })!
    }

    func insert(_ transaction: Transaction) throws {
        var toSave = transaction
        try dbPool?.write({ db in
            try toSave.save(db)
        })
    }

    func insert(_ transactions: [Transaction]) throws {
        for transaction in transactions {
            try self.insert(transaction)
        }
    }

    func fetchEthTransactions(address: String, completion: @escaping TransactionListClosure) {
        ethApi.getEthTransactions(address: address, startBlock: AppConfig.ethStartBlock ?? "") { (txListResponse, error) in
            if let response = txListResponse {
                if var txList = response.result, !txList.isEmpty {
                    txList = txList.map({ tx -> Transaction in
                        var newTx = tx
                        newTx.currency = Currency.ETH.rawValue
                        return newTx
                    })
                    txList = txList.filter({ $0.value != BigUInt("0")})
                    try? self.fillTransactions(txList, completion: { (mergedTxList, error) in
                        var listToInsert = mergedTxList
                        if listToInsert == nil || listToInsert!.isEmpty {
                            listToInsert = txList
                        }
                        if let listToInsert = listToInsert, !listToInsert.isEmpty {
                            try? self.insert(listToInsert)
                        }
                        completion(listToInsert, nil)
                    })
                }
            } else {
                completion(nil, error ?? AppErrors.unknowkError)
            }
        }
    }

    func fetchERC20Transactions(address: String, token: ERC20Token, completion: @escaping TransactionListClosure) {
        ethApi.getErc20Transactions(address: address, contractAddress: token.address, startBlock: AppConfig.ethStartBlock ?? "") { (txListResponse, error) in
            if let response = txListResponse {
                if var txList = response.result, !txList.isEmpty {
                    txList = txList.map({ tx -> Transaction in
                        var newTx = tx
                        newTx.currency = Currency.TIP.rawValue
                        return newTx
                    })

                    txList = txList.filter({ $0.value != BigUInt("0")})
                    try? self.fillTransactions(txList, completion: { (mergedTxList, error) in
                        var listToInsert = mergedTxList
                        if listToInsert == nil || listToInsert!.isEmpty {
                            listToInsert = txList
                        }

                        if let listToInsert = listToInsert, !listToInsert.isEmpty {
                            try? self.insert(listToInsert)
                        }
                        completion(listToInsert, nil)
                    })
                }
            } else {
                completion(nil, error ?? AppErrors.unknowkError)
            }
        }
    }

    func fillTransactions(_ txList: [Transaction], completion: @escaping TransactionListClosure) throws {
        tipApi.fillTransactions(txList) { (response, error) in
            if let error = error {
                completion(nil, error)
            } else if let response = response {
                let transactions = response.transactions
                completion(transactions, nil)
            } else {
                completion(nil, AppErrors.unknowkError)
            }
        }
    }
}
