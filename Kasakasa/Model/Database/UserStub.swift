//
//  UserStub.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-25.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

struct UserStub: Codable {

    var id: String?
    var username: String?
    var fullname: String?
    var address: String?
    var photoUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case fullname
        case address
        case photoUrl
    }
}
