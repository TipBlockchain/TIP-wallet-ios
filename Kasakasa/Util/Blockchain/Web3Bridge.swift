//
//  Web3Bridge.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import web3swift
import BigInt

class Web3Bridge {

    private lazy var tipToken: ERC20 = ERC20(Address(AppConfig.tipContractAddress))
    private lazy var web3: Web3 = Web3(infura: NetworkId(AppConfig.ethereumNetworkId), accessToken: AppConfig.infuraAccessToken)

    init() {
        self.loadKeystores()
    }

    private var _keystores: [BIP32Keystore]? = nil
    private var keystoreLoaded = false

    public var keystores: [BIP32Keystore] {
        if _keystores == nil {
            var keystores = [BIP32Keystore]()
            if let walletDirUrl = FileUtils.walletsDirectoryUrl(),
                let fileUrls = try? FileManager.default.contentsOfDirectory(at: walletDirUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]) {
                for url in fileUrls {
                    if let data = try? Data(contentsOf: url, options: .mappedIfSafe),
                        let ks = BIP32Keystore(data) {
                        keystores.append(ks)
                    }
                }
            }
            _keystores = keystores
        }
        return _keystores!
    }

    func generateMnemonic() throws -> Mnemonics {
        var mnemonics: Mnemonics?
        repeat {
            mnemonics = Mnemonics(entropySize: .b128)
        } while (mnemonics != nil && !isValidSeedPhrase(mnemonics!.string))

        let keystore = try! BIP32Keystore(mnemonics: mnemonics!)
        self.addToKeyStore(keystore)
        return mnemonics!
    }

    func generateBip39Wallet(password: String, path: String) throws -> Mnemonics? {
        let mnemonics = Mnemonics()
        let keystore = try! BIP32Keystore(mnemonics: mnemonics, password: password, prefixPath: path, aesMode: "aes-128-ctr")
        self.addToKeyStore(keystore)
        return mnemonics
    }

    private func loadKeystores() {
        guard !keystoreLoaded else {
            return
        }
        let _ = self.keystores
        let keystoreManager = KeystoreManager(keystores)
        Web3.default.keystoreManager = keystoreManager
        keystoreLoaded = true
    }

    func addToKeyStore(_ keystore: BIP32Keystore) {
        if !keystoreLoaded {
            self.loadKeystores()
        }
        if var keystores = _keystores {
            if !keystores.contains(where: { $0.addresses == keystore.addresses }) {
                keystores.append(keystore)
            }
            let keystoreManager = KeystoreManager(keystores)
            Web3.default.keystoreManager = keystoreManager
            _keystores = keystores
        }
    }

    func getTipBalanceInNaturalUnits(_ address: Address) throws -> String {
        return try tipToken.naturalBalance(of: address)
    }

    func getTipBalanceInWei(_ address: Address) throws -> BigUInt {
        return try tipToken.balance(of: address)
    }

    func sendTipTransaction(from: Address, to: Address, amount: String, password: String, gasPrice: BigUInt, gasLimit: BigUInt) throws -> TransactionSendingResult {
        let token = ERC20(Address(AppConfig.tipContractAddress), from: from, password: password)
        let from: Address = Web3.default.keystoreManager.addresses[0]

        // Sending 0.05 BKX
        let value = try NaturalUnits(amount)

        token.options.from = from
        token.options.gasPrice = gasPrice
        token.options.gasLimit = gasLimit
        let transaction = try token.transfer(to: to, amount: value)
        return transaction
    }

    func getEthBalanceInWei(_ address: Address) throws -> BigUInt {
        return try web3.eth.getBalance(address: address)
    }

    func getEthBalanceInNaturalUnits(_ address: Address) throws -> String {
        let balanceInWei = try self.getEthBalanceInWei(address)
        return balanceInWei.string(unitDecimals: Web3Units.eth.decimals)
    }

    func sendEthTransaction(from: Address, to: Address, amount: BigUInt, password: String) throws -> TransactionSendingResult {
        var options = Web3Options.default
        options.from = from
        return try web3.eth.sendETH(to: to, amount: amount).send(password: password, options: options)
    }

    func isValidSeedPhrase(_ phrase: String, language: BIP39Language = .english) -> Bool {
        let splits = phrase.split(separator: Character(language.separator))
        if splits.count != 12 {
            return false
        }
        let set = Set(splits)
        if set.count != splits.count {
            return false
        }
        for word in splits {
            if !language.words.contains(String(word)) {
                return false
            }
        }
        return true
    }
}
