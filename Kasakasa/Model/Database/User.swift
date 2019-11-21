//
//  User.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import GRDB

public final class User: Codable, DictionaryEncodable {

    var id: String
    var fullname: String?
    var username: String
    var countryCode: String?
    var phone: String?
    var country: String?
    var address: String
    var imageFileKey: String?
    var pictureUrl: String?
    var isContact: Bool?
    var isBlocked: Bool?
    var lastMessage: Date?
    var aboutMe: String?
    var photos: UserPhotos?
    var created: Date?

//    t.column("fromUser_id", .text)
//    t.column("fromUser_username", .text)
//    t.column("fromUser_fullname", .text)
//    t.column("fromUser_photoUrl", .text)
//
//    t.column("toUser_id", .text)
//    t.column("toUser_username", .text)
//    t.column("toUser_fullname", .text)
//    t.column("toUser_photoUrl", .text)

    enum CodingKeys: String, CodingKey, ColumnExpression {
        case id = "_id"
        case fullname
        case username
        case address
        case countryCode
        case country
        case phone
        case imageFileKey
        case pictureUrl
        case isContact
        case isBlocked
        case lastMessage
        case aboutMe
        case photos
        case created
//        case created
    }

    init(id: String, fullname: String?, username: String, address: String, countryCode: String? = nil, phone: String? = nil, country: String? = nil, imageFileKey: String? = nil, pictureUrl: String? = nil, isContact: Bool? = false, isBlocked: Bool? = false, lastMessage: Date? = nil, aboutMe: String? = nil, created: Date? = nil, photos: UserPhotos? = nil) {
        self.id = id
        self.fullname = fullname
        self.username = username
        self.address = address
        self.countryCode = countryCode
        self.phone = phone
        self.country = country
        self.isContact = isContact
        self.isBlocked = isBlocked
        self.lastMessage = lastMessage
        self.aboutMe = aboutMe
        self.photos = photos
        self.created = created
    }

    func firstname() -> String {
        let names = self.fullname?.components(separatedBy: " ") ?? []
        if names.count > 0 {
            return names.first!
        }
        return ""
    }

    func lastname() -> String {
        let names = self.fullname?.components(separatedBy: " ") ?? []
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

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter.defaultFormatter

        let id = try container.decode(String.self, forKey: .id)
        let fullname = try? container.decode(String.self, forKey: .fullname)
        let username = try container.decode(String.self, forKey: .username)
        let address = try container.decode(String.self, forKey: .address)
        let countryCode = try? container.decode(String.self, forKey: .countryCode)
        let phone = try? container.decode(String.self, forKey: .phone)
        let country = try? container.decodeIfPresent(String.self, forKey: .country)
        let imageFileKey = try? container.decode(String.self, forKey: .imageFileKey)
        let pictureUrl = try? container.decode(String.self, forKey: .pictureUrl)
        let isContact = try? container.decode(Bool.self, forKey: .isContact)
        let isBlocked = try? container.decode(Bool.self, forKey: .isBlocked)
        var lastMessage: Date? = nil
        if let lastMessageString = try? container.decode(String.self, forKey: .lastMessage) {
            lastMessage = dateFormatter.date(from: lastMessageString)
        }
        let aboutMe = try? container.decode(String.self, forKey: .aboutMe)
        var created: Date? = nil
        if let createdString = try? container.decode(String.self, forKey: .created) {
            created = dateFormatter.date(from: createdString)
        }
        let photos = try? container.decode(UserPhotos.self, forKey: .photos)

        self.init(id: id, fullname: fullname, username: username, address: address, countryCode: countryCode, phone: phone, country: country, imageFileKey: imageFileKey, pictureUrl: pictureUrl, isContact: isContact, isBlocked: isBlocked, lastMessage: lastMessage, aboutMe: aboutMe, created: created, photos: photos)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(fullname, forKey: .fullname)
        try container.encode(username, forKey: .username)
        try container.encode(address, forKey: .address)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(phone, forKey: .phone)
        try container.encode(imageFileKey, forKey: .imageFileKey)
        try container.encode(pictureUrl, forKey: .pictureUrl)
        try container.encode(isContact, forKey: .isContact)
        try container.encode(isBlocked, forKey: .isBlocked)
        try container.encode(lastMessage, forKey: .lastMessage)
        try container.encode(aboutMe, forKey: .aboutMe)
        try container.encode(created, forKey: .created)
        try container.encode(photos, forKey: .photos)
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

    enum Columns: String, CodingKey, ColumnExpression {
        case id, fullname, username, address, countryCode, phone, country, imageFileKey, pictureUrl, isContact, isBlocked, lastMessage, aboutMe, originalPhotoUrl, smallPhotoUrl, mediumPhotoUrl, created
    }

    public convenience init(row: Row) {
        let id = row[Columns.id] as String
        let fullname = row[Columns.fullname] as String?
        let username = row[Columns.username] as String
        let address = row[Columns.address] as String
        let countryCode = row[Columns.countryCode] as String?
        let phone = row[Columns.phone] as String?
        let country = row[Columns.country] as String?
        let imageFileKey = row[Columns.imageFileKey] as String?
        let pictureUrl = row[Columns.imageFileKey] as String?
        let isContact = row[Columns.isContact] as Bool?
        let isBlocked = row[Columns.isBlocked] as Bool?
        let aboutMe = row[Columns.aboutMe] as String?
        let lastMessage = row[Columns.lastMessage] as Date?
        let created = row[Columns.created] as Date?

        let originalPhoto = row[Columns.originalPhotoUrl] as String?
        let mediumPhoto = row[Columns.mediumPhotoUrl] as String?
        let smallPhoto = row[Columns.smallPhotoUrl] as String?

        let userPhotos = UserPhotos(original: originalPhoto, medium: mediumPhoto, small: smallPhoto)

        self.init(id: id, fullname: fullname, username: username, address: address, countryCode: countryCode, phone: phone, country: country, imageFileKey: imageFileKey, pictureUrl: pictureUrl, isContact: isContact, isBlocked: isBlocked, lastMessage: lastMessage, aboutMe: aboutMe, created: created, photos: userPhotos)
    }

    public func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.fullname] = fullname
        container[Columns.username] = username
        container[Columns.address] = address
        container[Columns.countryCode] = countryCode
        container[Columns.phone] = phone
        container[Columns.country] = country
        container[Columns.imageFileKey] = imageFileKey
        container[Columns.pictureUrl] = pictureUrl
        container[Columns.isContact] = isContact
        container[Columns.isBlocked] = isBlocked
        container[Columns.lastMessage] = lastMessage
        container[Columns.aboutMe] = aboutMe
        container[Columns.created] = created

        container[Columns.originalPhotoUrl] = photos?.original
        container[Columns.mediumPhotoUrl] = photos?.medium
        container[Columns.smallPhotoUrl] = photos?.small
    }
}

extension User {

    static func orderedByLastMessage() -> QueryInterfaceRequest<User> {
        return User.order(Columns.lastMessage)
    }

    static func contacts() -> QueryInterfaceRequest<User> {
        return User.filter(sql: "isContact = ?", arguments: [true])
    }
}
