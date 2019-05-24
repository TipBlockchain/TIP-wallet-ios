//
//  EtherscanApiRequest.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-23.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

enum EtherscanApiRequest {
    case getBalance(module: String, action: String, address: String, apiKey: String)
    case getEthTransactions(module: String, action: String, address: String, startBlock: String, endBlock: String, sort: String, apiKey: String)
    case getERC20Transactions(module: String, action: String, address: String, startBlock: String, endBlock: String, sort: String, apiKey: String)

    var baseUrl: String {
        return AppConfig.tipApiBaseUrl
    }
}
