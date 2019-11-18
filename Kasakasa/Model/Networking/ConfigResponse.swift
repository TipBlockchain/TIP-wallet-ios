//
//  ConfigResponse.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-23.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

struct ConfigResponse: Codable {
    var ios: Config
}

public struct Config: Codable {

    var tipApiUrl: String
    var tipApiKey: String
    var tipContractAddress: String
    var ethNodeUrl: String
    var infuraAccessToken: String?
    var etherscanApiKey: String
    var etherscanBaseUrl: String
    var buyTipUrl: String
    var appStartBlock: String
    var exchanges: [CryptoExchange]

    enum CodingKeys: String, CodingKey {
        case tipApiUrl = "tip_api_url"
        case tipApiKey = "tip_api_key"
        case tipContractAddress = "tip_contract_address"
        case ethNodeUrl = "eth_node_url"
        case infuraAccessToken = "infura_access_token"
        case etherscanApiKey = "etherscan_api_key"
        case etherscanBaseUrl = "etherscan_base_url"
        case buyTipUrl = "buy_tip_url"
        case appStartBlock = "app_start_block"
        case exchanges = "exchanges"
    }
}

