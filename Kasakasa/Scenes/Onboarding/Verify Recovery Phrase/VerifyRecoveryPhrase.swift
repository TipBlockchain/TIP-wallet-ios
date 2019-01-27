//
//  VerifyRecoveryPhrase.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol VerifyRecoveryPhraseView: class {
    func onWordsRemoved(phrase: String, firstIndex: Int, secondIndex: Int)
    func onPhraseVerified()
    func onVerificationError()
}
