//
//  WalletListPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class WalletListPresenter: BasePresenter {
    
    typealias View = WalletListViewController

    weak var view: WalletListViewController?

    private lazy var walletRepo: WalletRepository = WalletRepository.shared

    func loadWallets() {
        if let wallets = walletRepo.allWallets() {
            view?.onWalletsLoaded(wallets)
            checkForBalanceUpdates(inWallets: wallets)
        }
    }

    private func checkForBalanceUpdates(inWallets wallets: [Wallet]) {
        let wUtils = WalletUtils()
        let dGroup = DispatchGroup()

        var shouldUpdate = false
        for var wallet in wallets {
            dGroup.enter()
            wUtils.getBalance(forWallet: wallet) { (balance, error) in
                if let newBalance = balance, newBalance != wallet.balance {
                    wallet.balance = newBalance
                    shouldUpdate = true
                }
                dGroup.leave()
            }
        }
        if shouldUpdate {
            dGroup.notify(queue: DispatchQueue.main) {
                self.view?.onWalletsLoaded(wallets)
            }
        }

    }
}
