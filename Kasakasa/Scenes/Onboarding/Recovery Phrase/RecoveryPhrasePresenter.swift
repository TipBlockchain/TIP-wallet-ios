//
//  RecoveryPhrasePresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class RecoveryPhrasePresenter: BasePresenter {
    weak var view: RecoveryPhraseView?

    func getNewMnemonic() {
        let web3Bridge = Web3Bridge.shared
        do {
            let mnemonic = try web3Bridge.generateMnemonic()
            view?.onRecoveryPhraseCreated(mnemonic)
        } catch {
            view?.onError(AppErrors.genericError(message: error.localizedDescription))
        }
    }
}
