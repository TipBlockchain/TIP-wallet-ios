//
//  PhoneVerificationRequest.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public struct PhoneVerificationRequest: Codable, DictionaryEncodable {
    
    var countryCode: String
    var phoneNumber: String
    var verificationCode: String?

    var fullPhoneNumber: String {
        return "\(countryCode)\(phoneNumber)"
    }
}

