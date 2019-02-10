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

    func insert(_ user: User) {

    }

    func findUserById(_ id: String) -> User? {
        return nil
    }

    func findUserByUsername(_ username: String) -> User? {
        return nil
    }

    func fetchUserBySearch(_ query: String) -> [User] {
        return []
    }

    func fetchContacts() {

    }

    func loadContacts() -> [User] {
        return []
    }

    func addContact(_ contact: User) {

    }

    func removeContact(_ contact: User) {
        
    }
}
