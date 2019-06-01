//
//  SendTransferView.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-22.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt

protocol SendTransferView: class, BaseView {
    func onUserNotFound(_ username: String)
    func onInvalidRecipient()
    func onInsufficientEthBalanceError()
    func onInsufficientTipBalanceError()
    func onInvalidTransactionValueError()
    func onWalletError()
    func onSendPendingTransaction(_ tx: PendingTransaction)
    func onBalanceFetched(_ balance: String, forCurrency currency: Currency)
    func onBalanceFetchError(_ error: AppErrors)
    func onContactsFetched(_ contacts: [User])
    func onContactsFetchError(error: AppErrors)
    func onTransactionFeeCalculated(_ txFeeInWei: BigUInt, gasPriceInGwei: Float)
    func onTransactionFeeError()
}
