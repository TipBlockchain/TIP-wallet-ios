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
    case getERC20Transactions(module: String, action: String, address: String, contractAddress: String, startBlock: String, endBlock: String, sort: String, apiKey: String)

    var baseUrl: URL {
        return URL(string: AppConfig.etherscanBaseUrl)!
    }

    var method: HTTPMethod {
        return .GET
    }

    var url: URL {
        return self.baseUrl
    }

    var queryParams: Parameters {
        switch self {
        case .getBalance(let module, let action, let address, let apiKey):
            return ["module": module, "action": action, "address": address, "apikey": apiKey]
        case .getEthTransactions(let module, let action, let address, let startBlock, let endBlock, let sort, let apiKey):
            return ["module": module, "action": action, "address": address, "startblock": startBlock, "endblock": endBlock, "sort": sort, "apikey": apiKey]
        case .getERC20Transactions(let module, let action, let address, let contractAddress, let startBlock, let endBlock, let sort, let apiKey):
            return ["module": module, "action": action, "address": address, "contractaddress": contractAddress, "startblock": startBlock, "endblock": endBlock, "sort": sort, "apikey": apiKey]
        }
    }
}

extension EtherscanApiRequest: UrlRequestConvertible {
    func toUrlRequest() -> URLRequest {
        let url = self.url

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if !self.queryParams.isEmpty {
            urlComponents!.queryItems = [URLQueryItem]()
            for (key, value) in queryParams {
                let queryItem = URLQueryItem(name: key, value: value)
                urlComponents?.queryItems?.append(queryItem)
            }
            let escapedComponents = urlComponents?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            urlComponents?.percentEncodedQuery = escapedComponents
        }

        let request = NSMutableURLRequest(url: urlComponents!.url!)
        request.httpMethod = self.method.rawValue
        if request.allHTTPHeaderFields == nil {
            request.allHTTPHeaderFields = [:]
        }

        return request as URLRequest
    }
}
