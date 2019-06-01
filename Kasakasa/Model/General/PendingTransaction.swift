//
//  PendingTransaction.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-22.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt

struct PendingTransaction: Codable {
    var from: String
    var fromUsername: String?
    var to: String
    var toUsername: String?
    var value: BigUInt
    var currency: Currency
    var message: String?
}
