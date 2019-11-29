//
//  UserProfilePresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-09.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class UserProfilePresenter: BasePresenter {

    typealias View = UserProfileViewController

    weak var view: UserProfileViewController?
    lazy var userRepo = UserRepository.shared

    func addUserToContacts(_ user: User) {
        userRepo.addContact(user) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.view?.onContactAdded()
                } else if let error = error {
                    self.view?.onContactAddError(error)
                }
            }
        }
    }

    func removeContact(_ user: User) {
        userRepo.removeContact(user) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.view?.onContactRemoved(user)
                } else if let error = error {
                    self.view?.onContactRemovedError(error)
                }
            }
        }
    }
}
