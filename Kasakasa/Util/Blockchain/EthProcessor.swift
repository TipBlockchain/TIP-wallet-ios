//
//  EthProcessor.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-23.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt
import web3swift

class EthProcessor: ChainProcessor {

    let w3b = Web3Bridge.shared

    func getBalance(_ address: String) throws -> BigUInt {
        return try w3b.getEthBalance(foAddress: address)
    }

    func getBalaceAsync(_ address: String, completion: @escaping (BigUInt?, AppErrors?) -> Void) {
        w3b.getEthBalance(forAddress: address) { (balance, error) in
            completion(balance, error)
        }
    }

    func getBalanceInNaturalUnits(_ address: String) throws -> String? {
        let balanceBigUInt = try self.getBalance(address)
        let balanceString = Web3.Utils.formatToEthereumUnits(balanceBigUInt, toUnits: .eth, decimals: 4)
        return balanceString
    }
}
