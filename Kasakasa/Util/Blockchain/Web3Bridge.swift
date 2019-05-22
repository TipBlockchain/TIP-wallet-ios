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

//    private lazy var tipToken: ERC20 = ERC20(Address(AppConfig.tipContractAddress))
    private var keystoreManager = KeystoreManager.defaultManager
    private let web3 = Web3.InfuraRinkebyWeb3()
    init() {
//        self.loadKeystores()
    }

    private var _keystores: [BIP32Keystore]? = nil
    private var keystoreLoaded = false

    public static let shared = Web3Bridge()

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

    func restoreAccounts() -> [BIP32Keystore] {
        let dir = FileUtils.walletsDirectoryUrl()
        let path = dir!.path
        debugPrint("Wallet path = \(path)")
        keystoreManager = KeystoreManager.managerForPath(path, scanForHDwallets: true)
        debugPrint("Keystores are: \(keystoreManager!.bip32keystores)")
        var wallets: [Wallet] = []
//        for keystore in keystoreManager!.bip32keystores {
//            if let firstAddress = keystore.addresses?.first?.address, let keyData = try? JSONEncoder().encode(keystore.keystoreParams) {
//                let wallet = Wallet(address: firstAddress, data: keyData, name: "Some Wallet", isHD: true)
//                wallets.append(wallet)
//            }
//        }
        web3.addKeystoreManager(keystoreManager)
        return keystoreManager!.bip32keystores
    }

    func generateMnemonic() throws -> String {
        let bitsOfEntropy: Int = 128 // Entropy is a measure of password strength. Usually used 128 or 256 bits.
        var mnemonics: String? = nil
        repeat {
            mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!
        } while (mnemonics != nil && !isValidSeedPhrase(mnemonics!))

//        guard let keystore = try! BIP32Keystore(mnemonics: mnemonics!) else { return nil }
//        self.addToKeyStore(keystore)
        return mnemonics!
    }

    func createAccount(withPassword password: String) -> BIP32Keystore {
        let bitsOfEntropy: Int = 128 // Entropy is a measure of password strength. Usually used 128 or 256 bits.
        let mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!
        let keystore = try! BIP32Keystore(
            mnemonics: mnemonics,
            password: password,
            mnemonicsPassword: password,
            language: .english)!
        let name = "New HD Wallet"
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
//        let wallet = Wallet(address: address, data: keyData, name: name, isHD: true)
//
//        try? FileUtils.createWalletFile(forKeystore: keystore, password: password)
        debugPrint("Mnemonics: \(mnemonics)")
        debugPrint("Address: \(address)")
        keystoreManager = KeystoreManager([keystore])
        return keystore
    }

    func createAccount(withSeedPhrase seedPhrase: String, andPassword password: String) -> BIP32Keystore {
        let keystore = try! BIP32Keystore(
            mnemonics: seedPhrase,
            password: password,
            mnemonicsPassword: password,
            language: .english)!
        let address = keystore.addresses!.first!.address
        //        let wallet = Wallet(address: address, data: keyData, name: name, isHD: true)
        //
        //        try? FileUtils.createWalletFile(forKeystore: keystore, password: password)
        debugPrint("Address: \(address)")
        keystoreManager = KeystoreManager([keystore])
        return keystore
    }

    func unsafeGetPrivateKey(forWallet wallet: Wallet, password: String = "") -> String? {
        let ethereumAddress = EthereumAddress(wallet.address)!
        let pkData = try? keystoreManager?.UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress).toHexString()
        return pkData
    }

    func sendEthTransaction(value: String, fromAddress: String, toAddress toAddressString: String, withPassword password: String) throws -> TransactionSendingResult? {
        let walletAddress = EthereumAddress(fromAddress)! // Your wallet address
        let toAddress = EthereumAddress(toAddressString)!
        let contract = web3.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let tx = contract.write(
            "fallback",
            parameters: [AnyObject](),
            extraData: Data(),
            transactionOptions: options)!

        return try tx.send(password: password, transactionOptions: nil)
    }

    func sendERC20Transaction(value: String, from fromAddress: String, toAddress toAddressString: String, withPassword password: String, token: ERC20Token) throws -> TransactionSendingResult? {
        let walletAddress = EthereumAddress(fromAddress)! // Your wallet address
        let toAddress = EthereumAddress(toAddressString)!
        let erc20ContractAddress = EthereumAddress(token.address)
        let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .manual(BigUInt("21000000000"))
        options.gasLimit = .manual(BigUInt("90000"))
        let method = "transfer"
        let tx = contract.write(
            method,
            parameters: [toAddress, amount] as [AnyObject],
            extraData: Data(),
            transactionOptions: options)!
        return try tx.send(password: password, transactionOptions: nil)
    }

    func getEthBalance(foAddress address: String) throws -> BigUInt {
        let walletAddress = EthereumAddress(address)! // Address which balance we want to know
        let balanceResult = try web3.eth.getBalance(address: walletAddress)
//        let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 3)
        return balanceResult
    }

    func getERC20Balance(forAddress address: String, token: ERC20Token) throws -> BigUInt {
        let walletAddress = EthereumAddress(address)! // Your wallet address
        let exploredAddress = EthereumAddress(address)! // Address which balance we want to know. Here we used same wallet address
        let erc20ContractAddress = EthereumAddress(token.address)
        let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let method = "balanceOf"
        let tx = contract.read(
            method,
            parameters: [exploredAddress] as [AnyObject],
            extraData: Data(),
            transactionOptions: options)!
        let tokenBalance = try tx.call()
        let balanceBigUInt = tokenBalance["0"] as! BigUInt
//        let balanceString = Web3.Utils.formatToEthereumUnits(balanceBigUInt, toUnits: .eth, decimals: 3)
        return balanceBigUInt
    }

    func isValidSeedPhrase(_ phrase: String, language: BIP39Language = .english) -> Bool {
        return BIP39.seedFromMmemonics(phrase, password: "", language: language) != nil
    }
}

