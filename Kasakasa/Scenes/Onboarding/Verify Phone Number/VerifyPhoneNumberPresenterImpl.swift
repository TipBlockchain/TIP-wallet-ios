//
//  VerifyPhoneNumberPresenterImpl.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class VerifyPhoneNumberPresenterImpl: VerifyPhoneNumberPresenter {
    var view: VerifyPhoneNumberView? = nil

    private var apiService = TipApiService.sharedInstance

    func verifyPhoneNumber(_ verificationRequest: PhoneVerificationRequest) {
        apiService.checkPhoneVerification(verificationRequest: verificationRequest) { (response, error) in
            if let error = error {
                self.view?.onPhoneVerificationError(error: error)
            } else if let response = response {
            }
        }
    }
}
