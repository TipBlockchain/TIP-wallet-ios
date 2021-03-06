//
//  UserPhotos.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public struct UserPhotos: Codable, DictionaryEncodable {
    var original: String?
    var medium: String?
    var small: String?
}
