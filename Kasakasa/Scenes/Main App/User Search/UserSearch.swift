//
//  UserSearch.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-09.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol UserSearchView: class, BaseView {
    func onContactAdded(_ contact: User)
    func onContactAddedError()
    func onSearchSetupError()
    func onSearchError(_ error: AppErrors)
    func refreshSearchList(_ users: [User])
}
