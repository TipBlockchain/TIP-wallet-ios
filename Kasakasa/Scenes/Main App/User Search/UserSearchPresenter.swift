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

    func searchForUser(query: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if query.count >= 2 {
            self.perform(#selector(instantSearch(_:)), with: query, afterDelay: 0.5)
        }
    }

    @objc
    private func instantSearch(_ query: String) {
    }

    func addToContacts(_ contact: User) {

    }

}
