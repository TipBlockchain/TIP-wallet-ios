//
//  InfuraApiService.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-11-17.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import BigInt

class InfuraApiService {

    lazy var networkService = NetworkService()

    func getEthBalance(_ address: String, blockNumber: String = "latest", completion: @escaping (BigUInt?, AppErrors?)-> Void) {
        let headers = [
          "Content-Type": "application/json",
          "cache-control": "no-cache",
        ]
        let parameters = [
          "jsonrpc": "2.0",
          "method": "eth_getBalance",
          "params": [address, blockNumber],
          "id": 1
        ] as [String : Any]

        if let ethNodeUrlString = AppConfig.ethNodeUrl,
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            let request = NSMutableURLRequest(url: NSURL(string: ethNodeUrlString)! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
              if let error = error {
                completion(nil, AppErrors.error(error: error))
              } else {
                    if let data = data,
                    let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    var balanceHex = response["result"] as? String {
                        if balanceHex.starts(with: "0x") {
                            balanceHex = balanceHex.replacingOccurrences(of: "0x", with: "")
                        }
                        completion(BigUInt(balanceHex, radix: 16), nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
              }
            })

            dataTask.resume()
        } else {
            completion(nil, AppErrors.genericError(message: NSLocalizedString("Failed to get balance", comment: "")))
        }
    }

    func getEthBalance2(_ address: String, blockNumber: String = "latest", completion: @escaping (BigUInt?, AppErrors?)-> Void) {
        let request = InfuraApiRequest.getEthBalance(address, blockNumber: blockNumber)
        networkService.sendRequest(request: request) { (result, error) in
            if let data = result as? Data,
                let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let balanceHex = response["result"] as? String {
                completion(BigUInt(balanceHex, radix: 16), nil)
            } else {
                completion(nil, AppErrors.unknowkError)
            }
        }
    }

}
