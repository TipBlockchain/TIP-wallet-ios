//
//  TipProcessor.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-23.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import web3swift
import BigInt

class TipProcessor: ChainProcessor {

    static let tipToken = ERC20Token(name: "TIP Token", address: AppConfig.tipContractAddress, decimals: "18", symbol: "TIP")

    func getBalance(_ address: String) throws -> BigUInt {
        let w3b = Web3Bridge.shared
        return try w3b.getERC20Balance(forAddress: address, token: TipProcessor.tipToken)
    }

    func getBalanceInNaturalUnits(_ address: String) throws -> String? {
        let balanceBigUInt = try self.getBalance(address)
        let balanceString = Web3.Utils.formatToEthereumUnits(balanceBigUInt, toUnits: .eth, decimals: 4)
        return balanceString
    }
}
