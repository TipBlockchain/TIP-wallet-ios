//
//  Contacts.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-13.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol ContactsView: class, BaseView {
    func onContactsFetched(_ contancts: [User])
    func onNoContacts()
    func onContactsLoadError(_ error: AppErrors)
    func onContactsLoading()
    func onContactAdded(_ contact: User)
    func onContactRemoved(_ contact: User)
    func onContactAddError(_ error: AppErrors)
    func onContactRemoveError(_ error: AppErrors)
}
