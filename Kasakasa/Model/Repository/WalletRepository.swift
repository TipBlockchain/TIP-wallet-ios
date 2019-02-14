//
//  WalletRepository.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-19.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt
import GRDB

class WalletRepository: NSObject {

    static let shared = WalletRepository()
    private var dbPool = AppDatabase.dbPool

    var tipWallet: Wallet?
    var ethWallet: Wallet?

    override private init() {
    }

    func newWallet(withPhrase phrase: String, andPassword password: String) throws -> Wallet? {

        self.deleteAll()
        WalletUtils.deleteAllWalletFiles()

        let now = Date()
        let keystore = try WalletUtils.generateBip39Wallet(fromSeedPhrase: phrase, password: password)
        let walletFileUrl = try WalletUtils.createNewWalletFile(keystore: keystore, password: password)
        if walletFileUrl != nil, let address = keystore.addresses.first {
            let wallet = Wallet(address: address.address, filePath: walletFileUrl!.path, created: now, balance: BigInt(0), currency: Currency.TIP, isPrimary: true, blockNumber: BigInt(0), startBlockNumber: BigInt(0), lastSynced: now)
            tipWallet = wallet
            try self.insert(wallet)

            ethWallet = Wallet(address: address.address, filePath: walletFileUrl!.path, created: now, balance: BigInt(0), currency: Currency.ETH, isPrimary: false, blockNumber: BigInt(0), startBlockNumber: BigInt(0), lastSynced: now)
            try self.insert(ethWallet!)
            debugPrint("Created wallet: \(wallet)")
            return wallet
        }
        return nil
    }

    var _primaryWallet: Wallet? = nil

    func primaryWallet() throws -> Wallet? {
        if _primaryWallet == nil {
            _primaryWallet = try dbPool!.read({ db -> Wallet? in
                let wallet = try Wallet.filter(Column("isPrimary") == true).fetchOne(db)
                return wallet
            })
        }

        return _primaryWallet
    }

    func wallet(forCurrency currency: Currency) -> Wallet? {
        return try! dbPool!.read({ db -> Wallet? in
            return try Wallet.filter(Column("currency") == currency.rawValue).fetchOne(db)
        })
    }

    func wallet(forAddress address: String, andCurrency currency: Currency) -> Wallet? {
        return try! dbPool!.read({ db -> Wallet? in
            return try Wallet.filter(Column("address") == address && Column("currency") == currency.rawValue).fetchOne(db)
        })
    }

    func updateWallet(_ wallet: Wallet, newBalance balance: BigInt) {
        var walletToUpdate = wallet
        let _ = try! dbPool?.write({ db in
            walletToUpdate.balance = balance
            try walletToUpdate.update(db)
        })
    }

    func delete(byAddress address: String) throws {
        let _ = try! dbPool?.write({ db in
            try! Wallet.deleteOne(db, key: "")
        })
    }

    func insert(_ wallet: Wallet) throws {
        var walletToSave = wallet
        try dbPool?.write({db in
            try walletToSave.save(db)
        })
    }

    private func deleteAll() {
        let _ = try! dbPool?.write({ db in
            try Wallet.deleteAll(db)
        })
    }
}
