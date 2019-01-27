//
//  UserRepository.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class UserRepository {
    static var shared = UserRepository()

    var currentUser: User? {
        get {
            return AppDefaults.sharedInstance.currentUser
        }
        set {
            AppDefaults.sharedInstance.currentUser = newValue
        }
    }

    var demoAccountUser: User? {
        get {
            return AppDefaults.sharedInstance.demoAccountUser
        }
        set {
            AppDefaults.sharedInstance.demoAccountUser = newValue
        }
    }
}
