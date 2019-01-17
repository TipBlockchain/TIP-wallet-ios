//
//  Authorization.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public struct Authorization: Codable {
    var token: String
    var created: Date?
    var expires: Date?

    private enum CodingKeys: String, CodingKey {
        case token
        case created
        case expires
    }

    init(token: String, created: Date?, expires: Date?) {
        self.token = token
        self.created = created
        self.expires = expires
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter.defaultFormatter
        let token = try container.decode(String.self, forKey: .token)
        let createdString = try container.decode(String.self, forKey: .created)
        let expiresString = try container.decode(String.self, forKey: .expires)
        let created = dateFormatter.date(from: createdString)
        let expires = dateFormatter.date(from: expiresString)
        self.init(token: token, created: created, expires: expires)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter.defaultFormatter
        try container.encode(token, forKey: .token)
        try container.encode(dateFormatter.string(from: created ?? Date()), forKey: .created)
        try container.encode(dateFormatter.string(from: expires ?? Date()), forKey: .expires)
    }
}
