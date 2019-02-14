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
        apiService.getContactList { (response, error) in
            if let response = response {
                try? self.repository.insert(response.contacts)
                self.view?.onContactsFetched(response.contacts)
            }
        }
    }

    func addContact(_ contact: User) {

    }

    func removeContact(_ contact: User) {

    }
}

