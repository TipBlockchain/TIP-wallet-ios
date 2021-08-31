//
//  TipKeychain.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class TipKeychain {

    static let passwordItem = KeychainPasswordItem(service: AppConstants.keychainServiceName, account: AppConstants.keychainAccountPassword)
    static let recoveryPhraseItem = KeychainPasswordItem(service: AppConstants.keychainServiceName, account: AppConstants.keychainAccountRecoveryPhrase)

    static func savePassword(_ password: String) throws {
        try passwordItem.savePassword(password)
    }

    static func readPassword() throws -> String? {
        return try passwordItem.readPassword()
    }

    static func saveRecoveryPhrase(_ phrase: String) throws {
        try recoveryPhraseItem.savePassword(phrase)
    }

    static func readRecoveryPhrase() throws -> String? {
        return try recoveryPhraseItem.readPassword()
    }

    static func removeAllValues() throws {
        try passwordItem.deleteItem()
        try recoveryPhraseItem.deleteItem()
    }
}
