//
//  RecoveryPhraseView.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol RecoveryPhraseView: class {
    func onRecoveryPhraseCreated(_ phrase: String)
    func onError(_ error: AppErrors)
}
