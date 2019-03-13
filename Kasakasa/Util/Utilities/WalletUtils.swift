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
        let mnemonics = Mnemonics.seed(from: phrase, password: password)

        let keystore = try BIP32Keystore(seed: mnemonics, password: password, aesMode: "aes-128-ctr")
        return keystore
    }

    static func createNewWalletFile(keystore: BIP32Keystore, password: String) throws -> URL? {
        let fileUrl = try FileUtils.createWalletFile(forKeystore: keystore, password: password)
        return fileUrl
    }

    static func deleteAllWalletFiles() {
        if let fileUrl = FileUtils.walletsDirectoryUrl() {
            try? FileUtils.deleteFile(atUrl: fileUrl)
        }
    }
}
