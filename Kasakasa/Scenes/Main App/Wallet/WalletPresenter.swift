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

    func getBalance(forWallet wallet: Wallet) {
        let wUtil = WalletUtils()
        wUtil.getBalance(forWallet: wallet) { (balance, error) in
            self.mainQueue.async {
                if let error = error {
                    self.view?.onBalanceFetchError(error)
                } else if let balance = balance {
                    self.view?.onBalanceFetched(EthConvert.fromWei(balance, toUnit: .ether))
                }
            }
        }
    }

}
