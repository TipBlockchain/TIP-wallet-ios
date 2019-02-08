//
//  SplashScreenPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class SplashScreenPresenter: BasePresenter {
    typealias View = SplashScreenView

    weak var view: SplashScreenView?

    func checkForUserAndWallet() {
        if let currentUser = UserRepository.shared.currentUser,
            let tipWallet = try! WalletRepository.shared.primaryWallet(),
            currentUser.address == tipWallet.address {
            view?.goToMainApp()
        } else {
            view?.goToOnboarding()
        }

    }
}
