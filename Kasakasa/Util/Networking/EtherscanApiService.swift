//
//  EtherscanApiService.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-23.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class EtherscanApiService: NSObject {

    static let shared: EtherscanApiService = EtherscanApiService()
    let networkService = NetworkService()
    lazy var etherscanApiKey = AppConfig.etherscanApiKey ?? ""

    override private init() {}

    func getBalance(address: String) {

    }

    func getEthTransactions(address: String, startBlock: String, endBlock: String = "latest",
                            completion: @escaping ((EtherscanTxListResponse?, AppErrors?) -> Void)) {
        let request = EtherscanApiRequest.getEthTransactions(module: "account",
                                                             action: "txlist",
                                                             address: address,
                                                             startBlock: startBlock,
                                                             endBlock: endBlock,
                                                             sort: "asc",
                                                             apiKey: etherscanApiKey)
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder.epochDateDecoder.decode(EtherscanTxListResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    func getErc20Transactions(address: String, contractAddress: String, startBlock: String, endBlock: String = "latest", completion: @escaping ((EtherscanTxListResponse?, AppErrors?) -> Void)) {
        let request = EtherscanApiRequest.getERC20Transactions(module: "account",
                                                             action: "tokentx",
                                                             address: address,
                                                             contractAddress: contractAddress,
                                                             startBlock: startBlock,
                                                             endBlock: endBlock,
                                                             sort: "asc",
                                                             apiKey: etherscanApiKey)
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder.epochDateDecoder.decode(EtherscanTxListResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }
}
