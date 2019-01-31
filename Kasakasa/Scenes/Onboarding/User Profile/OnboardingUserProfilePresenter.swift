//
//  OnboardingUserProfilePresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-27.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class OnboardingUserProfilePresenter: NSObject, BasePresenter {
    typealias View = OnboardingUserProfileView

    weak var view: OnboardingUserProfileView?
    private var demoAccountFound = false
    private var walletRepository = WalletRepository.shared
    private var primaryWallet: Wallet?
    private var signupToken: String?
    private let apiService = TipApiService.sharedInstance

    func attach(_ v: OnboardingUserProfileView) {
        self.view = v
        if let wallet = walletRepository.primaryWallet {
            primaryWallet = wallet
        } else {
            view?.onWalletNotSetupError()
        }
        self.signupToken = AppDefaults.sharedInstance.pendingSignupToken
    }

    func checkUsername(_ username: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if username.count >= 2 {
            self.perform(#selector(doUsernameCheck(_:)), with: username, afterDelay: 0.5)
        }
    }

    @objc
    private func doUsernameCheck(_ username: String) {
        apiService.checkUsername(username) { (response, error) in
            if let response = response {
                DispatchQueue.main.async {
                    if response.isAvailable {
                        self.view?.onUsernameAvailable()
                    } else {
                        self.view?.onUsernameUnavailableError(isDemoAccount: response.isDemoAccount)
                    }
                }
            }
        }
    }

    func createAccount(firstname: String, lastname: String, username: String) {
        guard let primaryWallet = self.primaryWallet else {
            view?.onWalletNotSetupError()
            return
        }
        guard let signupToken = signupToken else {
            view?.onSignupTokenError()
            return
        }
        
        var fullname = firstname
        if !lastname.isEmpty {
            fullname.append(contentsOf: " \(lastname)")
        }
        let user = User(id: "", fullname: fullname, username: username, address: primaryWallet.address)
        apiService.createAccount(user: user, signupToken: signupToken, claimDemoAccount: demoAccountFound) { (newUser, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.view?.onErrorUpdatingUser(error!)
                }
                return
            }
            if let newUser = newUser, newUser.isValid {
                UserRepository.shared.currentUser = newUser
                self.getNewAuthorization()
            } else {
                DispatchQueue.main.async {
                    self.view?.onInvalidUser()
                }
            }
        }
    }

    private func getNewAuthorization() {
        AuthorizationRepository.shared.getNewAuthorization { (authorization, error) in
            DispatchQueue.main.async {
                self.view?.onAuthorizationFetched(authorization, error: error)
            }
        }
    }

    func uploadPhoto(_ image: UIImage) {

    }

    func checkForDemoAccount() {
        if let demoAccount = UserRepository.shared.demoAccountUser {
            demoAccountFound = true
            view?.onDemoAccountFound(demoAccount)
        }
    }

}
