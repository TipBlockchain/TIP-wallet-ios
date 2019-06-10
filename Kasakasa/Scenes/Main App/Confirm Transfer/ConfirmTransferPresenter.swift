//
//  ConfirmTransferPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-01.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt

class ConfirmTransferPresenter: BasePresenter {
    typealias View = ConfirmTransferViewController

    weak var view: ConfirmTransferViewController?
    private lazy var txRepo = TransactionRepository.shared

    private let  txQueue = DispatchQueue(label: "ConfirmTransfer")
    private let mainQueue = DispatchQueue.main

    func sendTransaction(_ transaction: PendingTransaction, password: String, gasPrice: BigUInt) {
        txQueue.async {
            self.txRepo.sendTransaction(transaction, withPassword: password, gasPrice: gasPrice) { (result, error) in
                self.mainQueue.async {
                    if let error = error {
                        self.view?.onTransactionError(error)
                    } else if result != nil {
                        self.view?.onTransactionSent()
                    }
                }
            }
        }

    }
}
