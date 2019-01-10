//
//  TipNetworkRequest.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

enum TipNetworkRequest {
    
    case getCountries
    case getCountry(code: String)
    case startPhoneVerification()
    case checkPhoneVerification()

    var baseUrl: URL {
        return URL(string: AppConfig.tipApiBaseUrl)!
    }

    var method: String {
        return "GET"
    }

    var url: URL {
        switch self {
        case .getCountries:
            return baseUrl.appendingPathComponent("/countries")
        default:
            return baseUrl.appendingPathComponent("/")
        }
    }
}

extension TipNetworkRequest: UrlRequestConvertible {
    func toUrlRequest() -> URLRequest {
        let url = self.url
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = self.method

        return request as URLRequest
    }
}
