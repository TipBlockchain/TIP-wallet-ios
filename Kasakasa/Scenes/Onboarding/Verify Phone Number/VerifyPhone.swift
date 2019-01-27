//
//  VerifyPhone.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol VerifyPhoneNumberView: BaseView {
    func onPhoneVerified(withExistingAccount account: User)
    func onPhoneVerified(withPendingSignup signup: PendingSignup)
    func onPhoneVerified(withPendingSignup signup: PendingSignup, andDemoAccount account: User)
    func onUnknownError(_ error: AppErrors)
    func onPhoneVerificationError(_ error: AppErrors)
}

protocol VerifyPhoneNumberPresenter: BasePresenter {
    func verifyPhoneNumber(_ verificationRequest: PhoneVerificationRequest)
}
