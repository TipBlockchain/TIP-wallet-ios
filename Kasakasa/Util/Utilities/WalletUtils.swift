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

    static func generateBip39Wallet(fromSeedPhrase phrase: String, password: String, language: BIP39Language = .english) throws -> BIP32Keystore? {
        if let bip32ks = try! BIP32Keystore.init(mnemonics: phrase, password: password, mnemonicsPassword: "", language: language) {
            return bip32ks
        }
        return nil
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

    static func walletFilesExist() -> Bool{
        if let walletDirUrl = FileUtils.walletsDirectoryUrl() {
            let bip32keystoreManager = KeystoreManager.managerForPath(walletDirUrl.path, scanForHDwallets: true)
            return (bip32keystoreManager?.addresses?.count != 0)
        }
        return false

    }
}
