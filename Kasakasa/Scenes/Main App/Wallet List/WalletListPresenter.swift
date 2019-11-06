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

    func checkForBalanceUpdates(inWallets wallets: [Wallet]) {
        let wUtils = WalletUtils()
        let dGroup = DispatchGroup()

        for var wallet in wallets {
            dGroup.enter()
            wUtils.getBalance(forWallet: wallet) { (balance, error) in
                if error == nil, let newBalance = balance {
                    wallet.balance = newBalance
                }
                dGroup.leave()
            }
        }

        dGroup.notify(queue: DispatchQueue.main) {
            self.view?.onWalletsLoaded(wallets)
        }

    }
}
