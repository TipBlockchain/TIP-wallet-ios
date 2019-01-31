//
//  User.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public struct User: Codable, DictionaryEncodable {
    var id: String
    var fullname: String
    var username: String
    var address: String
    var imageFileKey: String?
    var pictureUrl: String?
    var isContact: Bool?
    var isBlocked: Bool?
    var lastMessage: Date?

    var photos: UserPhotos?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullname
        case username
        case address
        case imageFileKey
        case pictureUrl
        case isContact
        case isBlocked
        case lastMessage
    }

    init(id: String, fullname: String, username: String, address: String) {
        self.id = id
        self.fullname = fullname
        self.username = username
        self.address = address
        self.isContact = false
        self.isBlocked = false
    }

    func firstname() -> String {
        let names = self.fullname.components(separatedBy: " ")
        if names.count > 0 {
            return names.first!
        }
        return ""
    }

    func lastname() -> String {
        let names = self.fullname.components(separatedBy: " ")
        if names.count > 1 {
            let othernames = names[1...names.count-1]
            return othernames.joined(separator: " ")
        }
        return ""
    }

    var isValid: Bool {
        return !(username.isEmpty || address.isEmpty || id.isEmpty)
    }

    var originalPhotoUrl: String? {
        return photos?.original
    }

    var smallPhotoUrl: String? {
        return photos?.small
    }

    var mediumPhotoUrl: String? {
        return photos?.medium
    }
}

extension User: Equatable {

    public static func == (lhs: User, rhs: User) -> Bool {
        return (lhs.id == rhs.id && lhs.username == rhs.username)
    }
}
