//
//  UserRepository.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import GRDB

typealias UserListClosure = ([User]?, AppErrors?) -> Void

class UserRepository {
    static var shared = UserRepository()
    private var dbPool = AppDatabase.dbPool

    var apiService: TipApiService = TipApiService.sharedInstance
    var currentUser: User? {
        get {
            return AppDefaults.shared.currentUser
        }
        set {
            AppDefaults.shared.currentUser = newValue
        }
    }

    var demoAccountUser: User? {
        get {
            return AppDefaults.shared.demoAccountUser
        }
        set {
            AppDefaults.shared.demoAccountUser = newValue
        }
    }

    func reset() {
        try? self.removeAllContacts()
        self.currentUser = nil
    }
    
    func findUserById(_ id: String) -> User? {
        return try? dbPool?.read({ db -> User? in
            return try? User.filter(Column("id") == id).fetchOne(db)
        })
    }

    func findUserByUsername(_ username: String) -> User? {
        return try? dbPool?.read({ db -> User? in
            return try? User.filter(Column("username") == username).fetchOne(db)
        })
    }

    func loadContactList(_ completion: @escaping UserListClosure) {
        let contacts = try? self.loadContacts()
        completion(contacts, nil)
    }
    
    func fetchContactList(_ completion: @escaping UserListClosure) {
        apiService.getContactList { (response, error) in
            if let response = response {
                let contacts = response.contacts
                try? self.insert(contacts)
                completion(contacts, nil)
            } else {
                completion(nil, error ?? AppErrors.unknowkError)
            }
        }
    }

    func fetchUserBySearch(_ query: String, completion: @escaping UserListClosure) {
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

    func loadCurrentUser(_ completion: @escaping(User?, AppErrors?) -> Void) {
        apiService.getMyAccount { (user, error) in
            if let user = user {
                self.currentUser = user
            }
            completion(user, error)
        }
    }

    func updatePhoto(_ photo: UIImage, completion: @escaping (User?, AppErrors?) -> Void) {
        apiService.uploadPhoto(photo) { (user, error) in
            if let user = user {
                self.currentUser = user
            }
            completion(user, error)
        }
    }
    
    func updateAboutMe(_ aboutMe: String, completion: @escaping (User?, AppErrors?) -> Void) {
        apiService.updateAboutMe(aboutMe) { (user, error) in
            if let user = user {
                self.currentUser = user
            }
            completion(user, error)
        }
    }

    func updateFullname(_ fullname: String, completion: @escaping (User?, AppErrors?) -> Void) {
        apiService.updateFullname(fullname) { (user, error) in
            if let user = user {
                self.currentUser = user
            }
            completion(user, error)
        }
    }

    func loadContacts() throws -> [User]? {
        return try dbPool?.read({ (db) in
            return try User.fetchAll(db, sql: "SELECT * FROM users WHERE isContact = ? ORDER BY fullname", arguments: [true])
        })
    }

    func addContact(_ contact: User, completion: @escaping (Bool, AppErrors?) -> Void) {
        apiService.addContact(contact) { (response, error) in
            if let response = response {
                if response.contacts.contains(contact.id) {
                    do {
                        try self.insertContact(contact)
                        debugPrint("User inserted")
                        completion(true, nil)
                    } catch {
                        completion(false, AppErrors.error(error: error))
                    }

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

    func removeContact(_ contact: User, completion: @escaping (Bool, AppErrors?) -> Void) {
        apiService.removeContact(contact) { (response, error) in
            if let response = response {
                if !response.contacts.contains(contact.id) {
                    do {
                        try self.deleteContact(contact)
                        completion(true, nil)
                    } catch {
                        completion(false, AppErrors.error(error: error))
                    }
                }
            }  else {
               if let error = error {
                   completion(false, error)
               } else {
                   completion(false, AppErrors.unknowkError)
               }
           }
        }
    }

    func removeAllContacts() throws {
        let _ = try dbPool?.write({ db in
            try? User.deleteAll(db)
        })
    }

    func insertContact(_ user: User) throws {
        var userToSave = user

        try dbPool?.write({db in
            userToSave.isContact = true
            try userToSave.save(db)
        })
    }

    func deleteContact(_ user: User) throws {
        var userToSave = user
        try dbPool?.write({ (db) in
            userToSave.isContact = false
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
