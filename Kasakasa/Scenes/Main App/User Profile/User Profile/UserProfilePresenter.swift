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
        userRepo.addContact(user) { added, error in
            if added {
                
            }
        }
    }
}
