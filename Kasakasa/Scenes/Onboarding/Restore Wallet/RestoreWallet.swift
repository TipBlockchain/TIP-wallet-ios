//
//  RestoreWallet.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-30.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol RestoreWalletView: class, BaseView {

    func onRecoveryPhraseVerified()
    func onEmptyRecoveryPhrase()
    func onInvalidRecoveryPhraseLength()
    func onInvalidRecoveryPhrase()
}
