//
//  RestoreWalletPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-30.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class RestoreWalletPresenter: BasePresenter {

    typealias View = RestoreWalletView
    weak var view: RestoreWalletView?

    func checkRecoveryPhrase(phrase: String) {
        if (phrase.isEmpty) {
            view?.onEmptyRecoveryPhrase()
            return
        }

        if (Web3Bridge().isValidSeedPhrase(phrase)) {
            view?.onRecoveryPhraseVerified()
        } else {
            view?.onInvalidRecoveryPhrase()
        }
    }
}
