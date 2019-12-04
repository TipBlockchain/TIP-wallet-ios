//
//  WalletPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-22.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class WalletPresenter: BasePresenter {
    typealias View = WalletViewController

    weak var view: WalletViewController?
    let mainQueue = DispatchQueue.main
    lazy var repo = TransactionRepository.shared

    func getBalance(forWallet wallet: Wallet) {
        let wUtil = WalletUtils()
        wUtil.getBalance(forWallet: wallet) { (balance, error) in
            self.mainQueue.async {
                if let error = error {
                    self.view?.onBalanceFetchError(error)
                } else if let balance = balance {
                    self.view?.onBalanceFetched(balance)
                }
            }
        }
    }

    func fetchTransactions(forWallet wallet: Wallet) {
        do {
            let existingTxList = try repo.transactions(forCurrency: wallet.currency)
//            self.view?.onTransactionsFetched(existingTxList)

            switch wallet.currency {
            case .ETH:
                repo.fetchEthTransactions(address: wallet.address) { (transactions, error) in
                    self.mainQueue.async {
                        if let transactions = transactions {
//                            if let newTxList = self.checkForNewTransactions(existingTxList, newList: transactions), !newTxList.isEmpty {
                                self.view?.onTransactionsFetched(transactions)
//                            }
                        } else {
                            self.view?.onTransactionFetchError(error ?? AppErrors.unknowkError)
                        }
                    }
                }
            case .TIP:
                repo.fetchERC20Transactions(address: wallet.address, token: TipProcessor.tipToken) { (transactions, error) in
                    self.mainQueue.async {
                        if let transactions = transactions {
                                self.view?.onTransactionsFetched(transactions)
                        } else {
                            self.view?.onTransactionFetchError(error ?? AppErrors.unknowkError)
                        }
                    }
                }
            }
        } catch {
            self.mainQueue.async {
                self.view?.onTransactionFetchError(AppErrors.error(error: error))
            }
        }
    }

    // Checks if oldList and newList are different. Returns difference or nil of no difference
    private func checkForNewTransactions(_ oldList: [Transaction], newList: [Transaction]) -> [Transaction]? {
        var diff: [Transaction] = []
        for tx in newList {
            if !oldList.contains(tx) {
                diff.append(tx)
            }
        }
        return diff
    }
}
