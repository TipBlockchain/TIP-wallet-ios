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
    private let tipApi = TipApiService.sharedInstance
    private let mainQueue = DispatchQueue.main

    func attach(_ v: OnboardingUserProfileView) {
        self.view = v
        do {
            if let wallet = try walletRepository.primaryWallet() {
                primaryWallet = wallet
            } else {
                view?.onWalletNotSetupError()
            }
            self.signupToken = AppDefaults.sharedInstance.pendingSignupToken
        } catch {
            view?.onWalletNotSetupError()
        }
    }

    func checkUsername(_ username: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if username.count >= 2 {
            self.perform(#selector(doUsernameCheck(_:)), with: username, afterDelay: 0.5)
        }
    }

    @objc
    private func doUsernameCheck(_ username: String) {
        tipApi.checkUsername(username) { (response, error) in
            if let response = response {
                self.mainQueue.async {
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
        tipApi.createAccount(user: user, signupToken: signupToken, claimDemoAccount: demoAccountFound) { (newUser, error) in
            guard error == nil else {
                self.mainQueue.async {
                    self.view?.onErrorUpdatingUser(error!)
                }
                return
            }
            if let newUser = newUser, newUser.isValid {
                UserRepository.shared.currentUser = newUser
                self.getNewAuthorization()
            } else {
                self.mainQueue.async {
                    self.view?.onInvalidUser()
                }
            }
        }
    }

    func uploadPhoto(_ image: UIImage) {
        UserRepository.shared.updatePhoto(image, completion: { (user, error) in
            self.mainQueue.async {
                if user != nil {
                    self.view?.onPhotoUploaded()
                } else {
                    self.view?.onPhotoUploadError(error ?? AppErrors.genericError(message: "Error uploading photo".localized))
                }
            }
        })
    }

    private func getNewAuthorization() {
        AuthorizationRepository.shared.getNewAuthorization { (authorization, error) in
            self.mainQueue.async {
                self.view?.onAuthorizationFetched(authorization, error: error)
            }
        }
    }

    func checkForDemoAccount() {
        if let demoAccount = UserRepository.shared.demoAccountUser {
            demoAccountFound = true
            self.mainQueue.async {
                self.view?.onDemoAccountFound(demoAccount)
            }
        }
    }
}
