//
//  SecureMessage.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-28.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public struct SecureMessage: Codable, DictionaryEncodable {
    var message: String
    var address: String
    var username: String
    var signature: String

    init(message: String, address: String, username: String, signature: String) {
        self.message = message
        self.address = address
        self.username = username
        self.signature = signature
    }
}
