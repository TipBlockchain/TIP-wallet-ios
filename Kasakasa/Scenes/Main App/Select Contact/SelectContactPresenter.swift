//
//  SelectContactPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-30.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class SelectContactPresenter: BasePresenter {
    
    typealias View = SelectContactViewController

    weak var view: SelectContactViewController?
    var repository = UserRepository.shared

    func attach(_ v: SelectContactViewController) {
        self.view = v
        self.fetchContactList()
    }

    func fetchContactList() {
        repository.loadContactList { contacts, error in
            DispatchQueue.main.async {
                if let contacts = contacts {
                    self.view?.onContactsFetched(contacts)
                } else if let error = error {
                    self.view?.onContactsFetchError(error)
                } else {
                    self.view?.onContactsFetchError(AppErrors.unknowkError)
                }
            }

        }
    }

    func verifyAddress(_ address: String) {
        let address = address.withHexPrefix()
        if TextUtils.isEthAddress(address) {
            view?.onAddressVerified(address)
        } else {
            view?.onAddressVerificationError(AppErrors.genericError(message: "Invalid crypto address."))
        }
    }
}
