//
//  ContactsPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-13.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class ContactsPresenter: BasePresenter {
    typealias View = ContactsView
    weak var view: ContactsView?
    var repository = UserRepository.shared
    var apiService = TipApiService.sharedInstance

    func loadContactLst() {

    }

    func fetchContactList() {
        repository.fetchContactList { contacts, error in
            if let contacts = contacts {
                self.view?.onContactsFetched(contacts)
            } else if let error = error {
                self.view?.onContactsLoadError(error)
            } else {
                self.view?.onContactsLoadError(AppErrors.unknowkError)
            }
        }
    }

    func addContact(_ contact: User) {

    }

    func removeContact(_ contact: User) {

    }
}

