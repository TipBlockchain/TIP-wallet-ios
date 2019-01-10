//
//  AppConstants.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

/*
 tip_api_url: "https://discoverapi1.dev.tipblockchain.io",
 eth_node_url: "https://rinkeby.infura.io/SSWOxqisHlJoSVWYy09p",
 tip_contract_address: "0xFE55d3E9583D1d7f9907367065737206F9751f6a",
 etherscan_api_key: "ZJPDFCKG8WSN5Y1NUERJM699QT615JWRNY",
 etherscan_base_url: "https://rinkeby.etherscan.io",
 buy_tip_url: "https://idex.market/eth/tip",
 app_start_block: 338200,
 */
enum AppConstants {
    static let tipApiBaseUrl = "tip_api_url"
    static let ethNodeUrl = "eth_node_url"
    static let tipContractAddress = "tip_contract_address"
    static let etherscanApiKey = "etherscan_api_key"
    static let etherscanBaseUrl = "etherscan_base_url"
    static let idexMarketUrl = "buy_tip_url"
    static let chainStartBlock = "app_start_block"
}
