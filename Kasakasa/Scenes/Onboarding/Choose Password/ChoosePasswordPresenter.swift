//
//  ChoosePasswordPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class ChoosePasswordPresenter: BasePresenter {
    typealias View = ChoosePasswordView

    weak var view: ChoosePasswordPresenter.View?
    private var existingUser: User?
    private var walletRepository = WalletRepository.shared

    func setExistingUser(_ user: User) {
        existingUser = user
    }

    func generateWallet(fromSeedPhrase phrase: String, andPassword password: String) {
        do {
            try walletRepository.newWallet(withPhrase: phrase, andPassword: password)
            view?.onWalletCreated()
        } catch {
            let appError = AppErrors.error(error: error)
            view?.onWalletCreationError(appError)
        }
    }
}
