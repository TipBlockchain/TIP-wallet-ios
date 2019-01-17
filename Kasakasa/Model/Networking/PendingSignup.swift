//
//  PendingSignup.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public struct PendingSignup: Codable {
    var token: String
    var phone: String
    var countryCode: String
}
