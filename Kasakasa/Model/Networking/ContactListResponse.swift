//
//  ContactListResponse.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-09.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

struct ContactListResponse: Codable {
    var contacts: [User]?
    var id: String?

    enum CodingKeys: String, CodingKey {
        case contacts
        case id = "_id"
    }

}
