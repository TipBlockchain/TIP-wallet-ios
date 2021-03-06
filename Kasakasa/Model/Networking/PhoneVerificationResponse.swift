//
//  PhoneVerificationResponse.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public struct PhoneVerificationResponse: Codable {
    var account: User?
    var demoAccount: User?
    var authorization: Authorization?
    var pendingSignup: PendingSignup?
}
