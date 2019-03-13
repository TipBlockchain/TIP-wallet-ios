//
//  ChainProcessor.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-23.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt

protocol ChainProcessor {
    func getBalance(_ address: String) throws -> BigUInt
}
