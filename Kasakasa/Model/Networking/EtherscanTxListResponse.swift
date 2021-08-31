//
//  EtherscanTxListResponse.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-25.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

struct EtherscanTxListResponse: Codable {

    var status: String?
    var message: String?
    var result: [Transaction]?
}
