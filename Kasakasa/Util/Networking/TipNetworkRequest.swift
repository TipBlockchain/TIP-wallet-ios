//
//  TipNetworkRequest.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PATCH
    case PUT
    case OPTIONS
    case HEAD
}

enum TipNetworkRequest {
    
    case getCountries
    case getCountry(code: String)
    case startPhoneVerification(verification: PhoneVerificationRequest)
    case checkPhoneVerification(verification: PhoneVerificationRequest)

    var baseUrl: URL {
        return URL(string: AppConfig.tipApiBaseUrl)!
    }

    var method: HTTPMethod {
        switch self {
        case .startPhoneVerification, .checkPhoneVerification:
            return .POST
        default:
            return .GET
        }
    }

    var headers: Json? {
        switch self {
        default:
            return [:]
        }
    }

    var body: Json? {
        switch self {
        case .startPhoneVerification(let verification), .checkPhoneVerification(let verification):
            return verification.dictionary()
        default:
            return nil
        }
    }

    var url: URL {
        switch self {
        case .getCountries:
            return baseUrl.appendingPathComponent("/countries")
        case .startPhoneVerification:
            return baseUrl.appendingPathComponent("/phones/verificationStart")
        case .checkPhoneVerification:
            return baseUrl.appendingPathComponent("/phones/verificationCheck")
        default:
            return baseUrl.appendingPathComponent("/")
        }
    }
}

extension TipNetworkRequest: UrlRequestConvertible {
    func toUrlRequest() -> URLRequest {
        let url = self.url
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = self.method.rawValue

        if let jsonBody = self.body, let data = try? JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted) {
//            let jsonString = jsonBody.JSONRe
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }

        return request as URLRequest
    }
}
