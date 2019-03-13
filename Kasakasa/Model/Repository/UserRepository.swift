//
//  UserRepository.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

typealias userListResponse = ([User]?, AppErrors?) -> Void
class UserRepository {
    static var shared = UserRepository()
    private var dbPool = AppDatabase.dbPool

    var apiService: TipApiService = TipApiService.sharedInstance
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

    func findUserById(_ id: String) -> User? {
        return nil
    }

    func findUserByUsername(_ username: String) -> User? {
        return nil
    }

    func fetchUserBySearch(_ query: String, completion: @escaping userListResponse) {
        apiService.search(byUsername: query) { (response, errors) in
            if let response = response, let users = response.users {
                completion(users, nil)
            } else if let errors = errors {
                completion(nil, errors)
            } else {
                completion(nil, AppErrors.unknowkError)
            }
        }
    }

    func fetchContacts() {

    }

    func loadContacts() throws -> [User]? {
        return try dbPool?.read({ (db) in
            return try User.fetchAll(db, "SELECT * FROM users WHERE isContact = ? ORDER BY lastMessage", arguments: [true])
        })
    }

    func addContact(_ contact: User, completion: @escaping (Bool, AppErrors?) -> Void) {
        apiService.addContact(contact) { (response, error) in
            if let response = response {
                if response.contacts.contains(contact.id) {
                    try! self.insertContact(contact)
                    debugPrint("User inserted")
                    completion(true, nil)
                    return
                }
            } else {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(false, AppErrors.unknowkError)
                }
            }
        }
    }

    func removeContact(_ contact: User) {
        
    }

    func insertContact(_ user: User) throws {
        var userToSave = user

        try dbPool?.write({db in
            userToSave.isContact = true
            try userToSave.save(db)
        })
    }

    func insert(_ contacts: [User]) throws {
        try dbPool?.write({ db in
            for var contact in contacts {
                contact.isContact = true
                try contact.save(db)
            }
        })
    }
}
