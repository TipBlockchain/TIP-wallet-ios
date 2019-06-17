//
//  VerifyPhoneNumberPresenterImpl.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class VerifyPhoneNumberPresenterImpl: VerifyPhoneNumberPresenter {
    weak var view: VerifyPhoneNumberView? = nil

    private var apiService = TipApiService.sharedInstance

    func verifyPhoneNumber(_ verificationRequest: PhoneVerificationRequest) {
        apiService.checkPhoneVerification(verificationRequest: verificationRequest) { (response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.view?.onPhoneVerificationError(error)
                } else if let response = response {
                    if let existingAccount = response.account, let authorization = response.authorization {
                        AuthorizationRepository.shared.currentAuthorization = authorization
                        UserRepository.shared.currentUser = existingAccount
                        self.view?.onPhoneVerified(withExistingAccount: existingAccount)
                    } else if let demoAccount = response.demoAccount, let pendingSignup = response.pendingSignup {
                        UserRepository.shared.demoAccountUser = demoAccount
                        self.view?.onPhoneVerified(withPendingSignup: pendingSignup, andDemoAccount: demoAccount)
                    } else if let pendingSignup = response.pendingSignup {
                        AppDefaults.shared.pendingSignupToken = pendingSignup.token
                        self.view?.onPhoneVerified(withPendingSignup: pendingSignup)
                    } else {
                        self.view?.onUnknownError(AppErrors.unknowkError)
                    }
                } else {
                    self.view?.onUnknownError(AppErrors.unknowkError)
                }
            }
        }
    }
}
