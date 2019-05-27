//
//  WalletUtils.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-26.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import web3swift
import BigInt

class WalletUtils: NSObject {

    private lazy var queue = DispatchQueue(label: "WalletUtils.queue")
    private lazy var bridge = Web3Bridge.shared
    let walletRepo = WalletRepository.shared

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

    func getBalance(forWallet wallet: Wallet, completion: @escaping ((BigUInt?, AppErrors?) -> Void)) {
        let currency = wallet.currency
        let chainProcessor: ChainProcessor!
        switch currency {
        case .TIP:
            chainProcessor = TipProcessor()
        case .ETH:
            chainProcessor = EthProcessor()
        }

        queue.async {
            do {
                let balanceBigUInt = try chainProcessor.getBalance(wallet.address)
                if wallet.balance != balanceBigUInt {
                    self.walletRepo.updateWallet(wallet, newBalance: balanceBigUInt)
                }
                completion(balanceBigUInt, nil)
            } catch {
                let apperror = AppErrors.error(error: error)
                completion(nil, apperror)
            }
        }
    }
}
