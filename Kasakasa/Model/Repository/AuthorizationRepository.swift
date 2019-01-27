//
//  AuthorizationRepository.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class AuthorizationRepository: NSObject {

    static var shared = AuthorizationRepository()

    private override init() {}

    var currentAuthorization: Authorization? {
        get {
            return AppDefaults.sharedInstance.authorization
        }
        set {
            AppDefaults.sharedInstance.authorization = newValue
        }
    }
}
