//
//  SendTransferPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-23.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt
import web3swift

class SendTransferPresenter: BasePresenter {

    typealias View = SendTransferView

    weak var view: SendTransferView?

    private lazy var userRepo = UserRepository.shared
    private lazy var walletRepo = WalletRepository.shared
    private lazy var web3Bridge: Web3Bridge = Web3Bridge.shared
    private lazy var dbPool = AppDatabase.dbPool

    private var tipWallet: Wallet?
    private var ethWallet: Wallet?

    func attach(_ v: SendTransferView) {
        self.view = v
    }

    func loadWallets() {
        if let tipWallet = walletRepo.wallet(forCurrency: .TIP) {
            self.tipWallet = tipWallet
            view?.onBalanceFetched(EthConvert.fromWei(tipWallet.balance, toUnit: .ether), forCurrency: .TIP)
            fetchBalance(forWallet: tipWallet)
        }
        if let ethWallet = walletRepo.wallet(forCurrency: .ETH) {
            self.ethWallet = ethWallet
            view?.onBalanceFetched(EthConvert.fromWei(ethWallet.balance, toUnit: .ether), forCurrency: .ETH)
            fetchBalance(forWallet: ethWallet)
        }
    }

    func loadContactList() {
        do {
            if let contacts = try userRepo.loadContacts() {
                view?.onContactsFetched(contacts)
            }
        } catch {
            view?.onContactsFetchError(error: AppErrors.error(error: error))
        }
    }

    func currencySelected(_ currency: Currency) {

    }

    func validateTransfer(usernameOrAddress: String, value: Double, transactionFee: Double, currency: Currency, message: String?) {

    }

    func calculateTransactionFee(gasPrice: Int) {

    }

    private func fetchBalance(forWallet wallet: Wallet) {
        DispatchQueue.global(qos: .background).async {
            do {
                var balance = BigUInt()

                switch wallet.currency {
                case .ETH:
                    let processor = EthProcessor()
                    balance = try processor.getBalance(wallet.address)
                case .TIP:
                    let processor = TipProcessor()
                    balance = try processor.getBalance(wallet.address)
                }
                if balance != wallet.balance {
                    try self.updateBalance(balance, forWallet: wallet)
                }
                DispatchQueue.main.async {
                    self.view?.onBalanceFetched(EthConvert.fromWei(balance, toUnit: .ether), forCurrency: wallet.currency)
                }
            } catch  {
                DispatchQueue.main.async {
                    self.view?.onBalanceFetchError(AppErrors.error(error: error))
                }
            }
        }

    }

    private func updateBalance(_ balance: BigUInt, forWallet wallet: Wallet) throws {
        var wallet = wallet
        try dbPool?.write({ db in
            wallet.balance = balance
            try wallet.update(db)
        })
    }
}
