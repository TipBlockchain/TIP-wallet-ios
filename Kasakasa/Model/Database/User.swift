//
//  User.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String
    var username: String
    var address: String
    var imageFileKey: String?
    var pictureUrl: String?
    var isContact: Bool
    var isBlocked: Bool
    var lastMessage: Date?

    var photos: UserPhotos?
}
