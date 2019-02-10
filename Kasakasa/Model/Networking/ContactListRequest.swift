//
//  ContactListRequest.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-09.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

struct ContactListRequest: Codable, DictionaryEncodable {
    var contactIds: [String]
}
