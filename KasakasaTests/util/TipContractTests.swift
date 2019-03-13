//
//  TipContractTests.swift
//  KasakasaTests
//
//  Created by John Warmann on 2019-03-05.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import XCTest
import BigInt
import web3swift
@testable import Kasakasa

class TipContractTests: XCTestCase {

    let address1 = Address("0xb6065c6739D1f457C316f4BaD48e99d0bfd8CFC8")
    let address2 = Address("0xd8445cfb241bb818364458dc667f95b5d24729ce")
    var contract: TipTokenContract?
    var web3Bridge: Web3Bridge!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let web3: Web3 = Web3(infura: NetworkId(AppConfig.ethereumNetworkId), accessToken: AppConfig.infuraAccessToken)
        web3Bridge = Web3Bridge()
        contract = try! TipTokenContract(web3: web3, abiString: Web3Utils.erc20ABI, at: Address(AppConfig.tipContractAddress), options: nil)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testKeystores() {
        let keystores = web3Bridge.keystores
        debugPrint("Keystores = \(keystores)")
    }
    func testBalanceOf() {
        let keystores = web3Bridge.keystores
        let address = keystores.first!.addresses.first
        let result = try! contract?.balance(of: address!)
        debugPrint("result = \(result)")
        XCTAssertTrue(result is BigUInt)
    }

    func testTransfer() {
//        let keystoreManager = KeystoreManager(
        let amount = BigUInt(2)
        var options = Web3Options()
        options.from = web3Bridge.keystores.first!.addresses.first
        options.gasLimit = BigUInt(95000)
        options.gasPrice = BigUInt("21", units: .gWei)

//        let result = try! contract?.transfer(to: address1, value: amount, password: "password", options: options)
//        let result = try! contract?.sendTransfer(to: address1, value: amount, options: options)
        let result = try? contract?.sendTransfer2(to: address1, value: amount, options: options)
        debugPrint("Transfer result = \(result)")
        XCTAssertNotNil(result)
    }

    func testSend() {
        let web3 = Web3(infura: .rinkeby, accessToken: AppConfig.infuraAccessToken)
        let contract = try! Web3Contract(web3: web3, abiString: Web3Utils.erc20ABI, at: Address(AppConfig.tipContractAddress), options: nil)

        let toAddress = Address("0x89f3fedcda6caa9da1c74f14ea48c1d256a6f60a")
        let amount = BigUInt(2)
        var options = Web3Options()
        options.from = web3Bridge.keystores.first!.addresses.first
        options.gasLimit = BigUInt(95000)
        options.gasPrice = BigUInt("21", units: .gWei)
        let value = BigUInt("1", units: .eth)
        let result = try? contract.method("transfer", parameters: [toAddress, value], options: options).call(options: options)


//        let gasLimit = try intermediate.estimateGas(options: options)
//        let sendResult = try? result?.send(password: "password", options: options)
        debugPrint("send result = \(result)")
        let exp = expectation(description: "wait for tx")
        self.wait(for: [exp], timeout: 60)

    }

    func testTokenBalanceTransfer() throws {
        // BKX TOKEN
        let web3 = Web3(infura: .rinkeby, accessToken: AppConfig.infuraAccessToken)
        let contractAddress = Address(AppConfig.tipContractAddress)
        let toAddress = Address("0x89f3fedcda6caa9da1c74f14ea48c1d256a6f60a")

        var keystores = web3Bridge.keystores
        let keystoreManager = KeystoreManager(keystores)
        web3.addKeystoreManager(keystoreManager)
        var options = Web3Options()
        options.from = web3Bridge.keystores.first!.addresses.first

        let contract = try web3.contract(Web3Utils.erc20ABI, at: contractAddress)
        let result = try! contract.method("transfer", args: toAddress, BigUInt(1), options: options).send(password: "password")
        debugPrint("result = \(result)")
        let exp = expectation(description: "wait for transaction")
        self.wait(for: [exp], timeout: 40)
    }

    func testTokenBalanceTransfer2(amount: BigUInt, to toAddress: Address) throws {
        let web3 = Web3(infura: .rinkeby, accessToken: AppConfig.infuraAccessToken)
        let contractAddress = Address(AppConfig.tipContractAddress)
        let toAddress = Address("0x89f3fedcda6caa9da1c74f14ea48c1d256a6f60a")

        var keystores = web3Bridge.keystores
        let keystoreManager = KeystoreManager(keystores)
        web3.addKeystoreManager(keystoreManager)
        var options = Web3Options()
        options.from = web3Bridge.keystores.first!.addresses.first

        let contract = try web3.contract(Web3Utils.erc20ABI, at: contractAddress)
        let result = try! contract.method("transfer", args: toAddress, amount, options: options).call(options: options)
    }

    func testGetPrivateKey() {
        let keystores = web3Bridge.keystores
        let password = "password"
        let keystore = keystores.first!
        let privateKey = try! keystore.UNSAFE_getPrivateKeyData(password: password, account: keystore.addresses[0])
        debugPrint(("private key = \(privateKey)"))
    }

    func testSerializeRootNode() {
        let keystores = web3Bridge.keystores
        let first = keystores.first!

        let string = try! first.serializeRootNodeToString()
        debugPrint("stirng = \(string)")
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
