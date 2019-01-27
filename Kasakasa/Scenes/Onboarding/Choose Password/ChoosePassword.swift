//
//  ChoosePassword.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol ChoosePasswordView: class, BaseView {
    func onWalletCreated()
    func onWalletRestored()
    func onWalletNotMatchingExistingError()
    func onWalletCreationError(_ error: AppErrors)
}
