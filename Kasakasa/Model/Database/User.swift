//
//  User.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import GRDB

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

    init(id: String, fullname: String, username: String, address: String, imageFileKey: String? = nil, pictureUrl: String? = nil, isContact: Bool? = false, isBlocked: Bool? = false, lastMessage: Date? = nil, photos: UserPhotos? = nil) {
        self.id = id
        self.fullname = fullname
        self.username = username
        self.address = address
        self.isContact = isContact
        self.isBlocked = isBlocked
        self.lastMessage = lastMessage
        self.photos = photos
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

// Mark - database stuff

extension  User: TableRecord {
    public static var databaseTableName: String {
        return "users"
    }
}

extension User: FetchableRecord, MutablePersistableRecord {

    enum Columns: String, ColumnExpression {
        case id, fullname, username, address, imageFileKey, pictureUrl, isContact, isBlocked, lastMessage, originalPhoto, smallPhoto, mediumPhoto
    }

    public init(row: Row) {
        let id = row[Columns.id] as String
        let fullname = row[Columns.fullname] as String
        let username = row[Columns.username] as String
        let address = row[Columns.address] as String
        let imageFileKey = row[Columns.imageFileKey] as String
        let pictureUrl = row[Columns.imageFileKey] as String
        let isContact = row[Columns.isContact] as Bool
        let isBlocked = row[Columns.isBlocked] as Bool
        let lastMessage = row[Columns.lastMessage] as Date

        let originalPhoto = row[Columns.originalPhoto] as String
        let mediumPhoto = row[Columns.mediumPhoto] as String
        let smallPhoto = row[Columns.smallPhoto] as String

        let userPhotos = UserPhotos(original:  originalPhoto, medium: mediumPhoto, small: smallPhoto)

        self.init(id: id, fullname: fullname, username: username, address: address, imageFileKey: imageFileKey, pictureUrl: pictureUrl, isContact: isContact, isBlocked: isBlocked, lastMessage: lastMessage, photos: userPhotos)
    }

    public func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.fullname] = fullname
        container[Columns.username] = username
        container[Columns.address] = address
        container[Columns.imageFileKey] = imageFileKey
        container[Columns.pictureUrl] = pictureUrl
        container[Columns.isContact] = isContact
        container[Columns.isBlocked] = isBlocked
        container[Columns.lastMessage] = lastMessage

        container[Columns.originalPhoto] = photos?.original
        container[Columns.mediumPhoto] = photos?.medium
        container[Columns.smallPhoto] = photos?.small
    }
}
