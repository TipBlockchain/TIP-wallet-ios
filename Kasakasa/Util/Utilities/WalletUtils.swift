//
//  WalletUtils.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-26.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import web3swift

class WalletUtils: NSObject {

    static func generateBip39Wallet(fromSeedPhrase phrase: String, password: String) throws -> BIP32Keystore {
        let mnemonics = try Mnemonics(phrase)
        let keystore = try BIP32Keystore(mnemonics: mnemonics, password: password)
        return keystore
    }

    static func createNewWalletFile(keystore: BIP32Keystore, password: String) throws -> URL? {
        let fileUrl = try FileUtils.createWalletFile(forKeystore: keystore)
        return fileUrl
    }
}
