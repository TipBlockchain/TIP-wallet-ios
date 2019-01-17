//
//  VerifyPhone.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol VerifyPhoneNumberView: BaseView {
    func onPhoneVerifiedWithExistingAccount(_: User)
    func onPhoneVerifiedWithPendingAccount(_: User)
    func onPhoneVerifiedWithPendingAndDemoAccount(pendingAccount: User, demoAccount: User)
    func onUnknownError(err: AppErrors)
    func onPhoneVerificationError(error: AppErrors)
}

protocol VerifyPhoneNumberPresenter: BasePresenter {
    func verifyPhoneNumber(_ verificationRequest: PhoneVerificationRequest)
}
