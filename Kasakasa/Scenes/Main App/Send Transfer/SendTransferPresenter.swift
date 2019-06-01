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
    private let decimals = 3
    private let estimatedGasInWei = BigUInt("59000")
    private var mainQueue = DispatchQueue.main

    func attach(_ v: SendTransferView) {
        self.view = v
    }

    func loadWallets() {

        if let tipWallet = walletRepo.wallet(forCurrency: .TIP) {
            self.tipWallet = tipWallet
            view?.onBalanceFetched(EthConvert.toEthereumUnits(tipWallet.balance, decimals: decimals) ?? "0", forCurrency: .TIP)
            fetchBalance(forWallet: tipWallet)
        }
        if let ethWallet = walletRepo.wallet(forCurrency: .ETH) {
            self.ethWallet = ethWallet
            view?.onBalanceFetched(EthConvert.toEthereumUnits(ethWallet.balance, decimals: decimals) ?? "0", forCurrency: .ETH)
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
        if currency == .ETH, let ethWallet = self.ethWallet {
            self.fetchBalance(forWallet: ethWallet)
        } else if currency == .TIP, let tipWallet = self.tipWallet {
            self.fetchBalance(forWallet: tipWallet)
        }
    }

    func calculateTransactionFee(gasPrice: Float) {
        let gasPriceInWei = EthConvert.toWei(BigUInt(integerLiteral: UInt64(gasPrice.rounded(.toNearestOrEven))), fromUnit: .gwei)
        if let calculatedTxFee = gasPriceInWei?.multiplied(by: estimatedGasInWei) {
            view?.onTransactionFeeCalculated(calculatedTxFee, gasPriceInGwei: gasPrice)
        } else {
            view?.onTransactionFeeError()
        }
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
                    self.view?.onBalanceFetched(EthConvert.toEthereumUnits(balance, decimals: self.decimals) ?? "0", forCurrency: wallet.currency)
                }
            } catch  {
                DispatchQueue.main.async {
                    self.view?.onBalanceFetchError(AppErrors.error(error: error))
                }
            }
        }
    }

    func validateTransfer(usernameOrAddress: String, value: NSDecimalNumber, txFeeInWei: BigUInt, currency: Currency, message: String?) {

        var wallet: Wallet? = nil
        switch (currency) {
        case .TIP:
            wallet = tipWallet
        case .ETH:
            wallet = ethWallet
        }

        guard wallet != nil else {
            view?.onWalletError()
            return
        }

        guard TextUtils.isEthAddress(usernameOrAddress) || TextUtils.isUsername(usernameOrAddress) else {
            self.view?.onInvalidRecipient()
            return
        }

        guard value != NSDecimalNumber.zero else {
            self.view?.onInvalidTransactionValueError()
            return
        }
        
        // Check user balances are sufficient
        let valueInWei = EthConvert.toWei(value)
        let ethBalanceInWei = ethWallet!.balance
        let accountBalance = wallet!.balance

        guard let txValueInWei = valueInWei else {
            view?.onInvalidTransactionValueError()
            return
        }

        if currency == .ETH && txValueInWei + txFeeInWei > accountBalance {
            view?.onInsufficientEthBalanceError()
            return
        }

        if currency == .TIP && txFeeInWei > ethBalanceInWei {
            view?.onInsufficientEthBalanceError()
            return
        }

        // Check that sufficient funds exist
        if currency == .TIP && txValueInWei > accountBalance {
            view?.onInsufficientTipBalanceError()
            return
        }

        var address: String?
        var username: String?

        if (TextUtils.isEthAddress(usernameOrAddress)) {
            address = usernameOrAddress
            let pending = PendingTransaction(
                from: wallet!.address,
                fromUsername: userRepo.currentUser!.username,
                to: address!,
                toUsername: nil,
                value: txValueInWei,
                currency: currency,
                message: nil)
            view?.onSendPendingTransaction(pending)
        } else if (TextUtils.isUsername(usernameOrAddress)) {
            username = usernameOrAddress
            let user = userRepo.findUserByUsername(username!)
            if let user = user {
                if (!TextUtils.isEthAddress(user.address)) {
                    view?.onInvalidRecipient()
                    return
                }
                let pending = PendingTransaction(
                    from: wallet!.address,
                    fromUsername: userRepo.currentUser!.username,
                    to: user.address,
                    toUsername: user.username,
                    value: txValueInWei,
                    currency: currency,
                    message: nil
                )
                view?.onSendPendingTransaction(pending)
            } else {
                view?.onUserNotFound(username!)
            }
        } else {
            view?.onInvalidRecipient()
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
