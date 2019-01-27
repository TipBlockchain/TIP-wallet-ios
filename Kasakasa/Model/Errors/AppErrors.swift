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
    case fileError
    case unknowkError
    case error(error: Error)

    var message: String {
        switch self {
        case .genericError(let message):
            return message
        case .networkError(let body):
            return body["message"] as? String ?? "Error"
        case .fileError:
            return "File does not exists".localized
        case .unknowkError:
            return "Unknown Error".localized
        case .error(let err):
            return err.localizedDescription
        }
    }

    var localizedDescription: String {
        return message
    }

    var body: Json {
        switch self {
        case .genericError(let message):
            return ["message": message]
        case .networkError(let body):
            return body
        case .fileError:
            return ["message": "File error".localized]
        case .unknowkError:
            return ["message": "Unknown Error".localized]
        case .error(let err):
            return ["message": err.localizedDescription]
        }
    }
}
