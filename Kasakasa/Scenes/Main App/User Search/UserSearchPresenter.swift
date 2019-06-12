//
//  UserSearchPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-09.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class UserSearchPresenter: NSObject, BasePresenter {
    typealias View = UserSearchView
    weak var view: UserSearchView?
    private var apiService = TipApiService.sharedInstance
    private var userRepository = UserRepository.shared
    private let mainQueue = DispatchQueue.main

    func searchForUser(query: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if query.count >= 2 {
            self.perform(#selector(instantSearch(_:)), with: query, afterDelay: 0.5)
        }
    }

    @objc
    private func instantSearch(_ query: String) {
        userRepository.fetchUserBySearch(query) { (users, errors) in
            if let users = users {
                var filteredResults = users.filter({ $0.id != self.userRepository.currentUser?.id })
                if let contacts = try? self.userRepository.loadContacts() {
                    filteredResults = filteredResults.map({
                        var rv = $0
                        if contacts.contains($0) {
                            rv.isContact = true
                        }
                        return rv
                    })
                }
                self.mainQueue.async {
                    self.view?.refreshSearchList(filteredResults)
                }
            } else if let errors = errors {
                self.mainQueue.async {
                    self.view?.onSearchError(errors)
                }
            }
        }
    }

    func addToContacts(_ contact: User) {
        userRepository.addContact(contact) { (success, errror) in
            self.mainQueue.async {
                if success {
                    self.view?.onContactAdded(contact)
                } else {
                    self.view?.onContactAddedError()
                }
            }
        }
    }
}
