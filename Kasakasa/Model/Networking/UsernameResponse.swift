//
//  UsernameResponse.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-27.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public struct UsernameResponse: Codable {
    var username: String
    var isAvailable: Bool
    var isDemoAccount: Bool

    private enum CodingKeys: String, CodingKey {
        case username
        case isAvailable = "available"
        case isDemoAccount
    }
}
 
