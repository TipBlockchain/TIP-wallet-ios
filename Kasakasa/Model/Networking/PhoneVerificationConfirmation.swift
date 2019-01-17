//
//  PhoneVerificationConfirmation.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public struct PhoneVerificationConfirmation: Codable {
    var message: String
    var secondsToExpire: Int
    var uuid: String
    var success: Bool
}
