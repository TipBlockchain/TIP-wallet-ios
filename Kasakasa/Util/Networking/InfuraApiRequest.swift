//
//  InfuraApiRequest.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-11-17.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

enum InfuraApiRequest {
    case getEthBalance(_ address: String, blockNumber: String)

    var baseUrl: URL {
        return URL(string: AppConfig.etherscanBaseUrl)!
    }

    var method: HTTPMethod {
        return .POST
    }

    var url: URL {
        return self.baseUrl
    }


    var queryParams: Parameters {
        return [:]
    }

    var httpBody: Data? {
        switch self {
        case .getEthBalance(let address, let blockNumber):
            let parameters = [
              "jsonrpc": "2.0",
              "method": "eth_getBalance",
              "params": [address, blockNumber],
              "id": 1
            ] as [String : Any]

            return try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
    }
}

extension InfuraApiRequest: UrlRequestConvertible {
    
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

        request.allHTTPHeaderFields = [:]

        if let httpBody = self.httpBody {
            request.httpBody = httpBody
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("no-cache", forHTTPHeaderField: "cache-control")
        }

        return request as URLRequest
    }
}
