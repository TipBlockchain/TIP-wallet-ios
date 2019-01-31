//
//  OnboardingUserProfile.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-27.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol OnboardingUserProfileView: class, BaseView {
    func onDemoAccountFound(_ user: User)
    func onPhotoUploaded()
    func onErrorUpdatingUser(_ error: AppErrors)
    func onWalletNotSetupError()
    func onSignupTokenError()
    func onInvalidUser()
    func onUsernameAvailable()
    func onUsernameUnavailableError(isDemoAccount: Bool)
    func onAuthorizationFetched(_ auth: Authorization?, error: AppErrors?)
}
