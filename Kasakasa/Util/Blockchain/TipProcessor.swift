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

    func getBalance(_ address: String) throws -> BigUInt {
        let w3b = Web3Bridge()
        return try w3b.getTipBalanceInWei(Address(address))
    }

    func getBalanceInNaturalUnits(_ address: String) throws -> String {
        let w3b = Web3Bridge()
        return try w3b.getTipBalanceInNaturalUnits(Address(address))
    }
}
