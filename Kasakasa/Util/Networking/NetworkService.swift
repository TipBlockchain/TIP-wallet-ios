//
//  NetworkService.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-06.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

typealias NetworkCompletionHandler = (_ response: Any?, _ error: AppErrors?) -> Void

class NetworkService: NSObject {

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }()

    func sendRequest(request: UrlRequestConvertible, completion: @escaping NetworkCompletionHandler) -> Void {

        let task = session.dataTask(with: request.toUrlRequest()) { (data, response, error) in
            var serializedResponse: Any? = nil
            if let data = data {
                serializedResponse = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            }

            if let error = error {
                if let json = serializedResponse as? Json {
                   let appError = AppErrors.networkError(body: json)
                    return completion(nil, appError)
                } else {
                    let appError = AppErrors.genericError(message: error.localizedDescription)
                    return completion(nil, appError)
                }
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                if let json = serializedResponse as? Json, let errorJson = json["error"] as? Json {
                    let appError = AppErrors.networkError(body: errorJson)
                    completion(nil, appError)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
                return
            }

            completion(data, nil)
        }
        task.resume()
    }
}
