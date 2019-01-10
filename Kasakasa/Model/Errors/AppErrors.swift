//
//  Errors.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-06.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public enum AppErrors: Error {
    
    case genericError(message: String)
    case networkError(body: Json)
    case unknowkError

    var message: String? {
        switch self {
        case .genericError(let message):
            return message
        case .networkError(let body):
            return body["message"] as? String
        case .unknowkError:
            return "Unknown Error".localized
        }
    }

    var body: Json {
        switch self {
        case .genericError(let message):
            return ["message": message]
        case .networkError(let body):
            return body
        case .unknowkError:
            return ["message": "Unknown Error".localized]
        }
    }
}
