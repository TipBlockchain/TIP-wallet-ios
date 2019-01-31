//
//  WalletRepository.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-19.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt

class WalletRepository: NSObject {

    static let shared = WalletRepository()

    var tipWallet: Wallet?
    var ethWallet: Wallet?

    var primaryWallet: Wallet? {
        return tipWallet
    }
    
    override private init() {
    }

    func newWallet(withPhrase phrase: String, andPassword password: String) throws -> Wallet? {
        let now = Date()
        let keystore = try WalletUtils.generateBip39Wallet(fromSeedPhrase: phrase, password: password)
        let walletFileUrl = try WalletUtils.createNewWalletFile(keystore: keystore, password: password)
        if walletFileUrl != nil, let address = keystore.addresses.first {
            let wallet = Wallet(address: address.address, filePath: walletFileUrl!.path, created: now, balance: BigInt(0), currency: Currency.TIP, isPrimary: true, blockNumber: BigInt(0), startBlockNumber: BigInt(0), lastSynced: now)
            tipWallet = wallet

            ethWallet = Wallet(address: address.address, filePath: walletFileUrl!.path, created: now, balance: BigInt(0), currency: Currency.ETH, isPrimary: true, blockNumber: BigInt(0), startBlockNumber: BigInt(0), lastSynced: now)
            debugPrint("Created wallet: \(wallet)")
            return wallet
        }
        return nil
    }

    func delete(byAddress addrss: String) {
        
    }

}
