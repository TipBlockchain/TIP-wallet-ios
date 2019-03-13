//
//  TipContract.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-03-02.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import web3swift
import BigInt
import PromiseKit

public class TipTokenContract {

    var contract: Web3Contract?
    var web3: Web3!
    private var address: Address!

    init(web3 web3Instance: Web3, abiString: String, at address: Address? = nil, options: Web3Options? = nil) throws {
        self.address = address
        contract = try Web3Contract(web3: web3Instance, abiString: abiString, at: address, options: options)
    }

    public func balance(of address: Address) throws  -> BigUInt? {
        let balance = try contract?.method("balanceOf", parameters: [address.address], extraData: Data(), options: nil).call(options: nil).uint256()
        debugPrint("intermediate result is \(balance)")
        return balance
    }

    public func transfer(from: Address, to: Address, value: BigInt, options: Web3Options? = nil) throws  -> Any? {
        let result = try contract?.method("transfer", parameters: [to, value], extraData: Data(), options: options).call(options: nil).next()
        debugPrint(("result is \(result)"))
        return result
    }

    public func transfer(to: Address, value: BigUInt, password: String = "", options: Web3Options? = nil) throws -> Any? {
//        Guide.ERC20_token_guide
        let result = try self.address.send("transfer(address,uint256)", to, value, password: password, options: options).wait()

        return result
    }

    public func sendTransfer(to toAddress: Address, value: BigUInt, options: Web3Options? = nil) throws -> TransactionSendingResult? {
        let result = try contract?.method("transfer", parameters: [toAddress, value], options: options).send(password: "password", options: options)
        return result
    }

    public func sendTransfer2(to toAddress: Address, value: BigUInt, options: Web3Options? = nil) throws -> Any? {
        var options = options
        let result = try contract?.method("transfer", parameters: [toAddress, value], options: options)
        guard let intermediate = result else { return nil }
        let gasLimit = try intermediate.estimateGas(options: options)
//        options?.gasLimit = gasLimit.
        return try result!.send(password: "password", options: options)
//        return try intermediate.send(password: "password", options: options)
//        return try intermediate.send(password: "password", options: options)
    }
}
