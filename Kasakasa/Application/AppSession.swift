//
//  AppSession.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-11.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class AppSession {

    static func signOut() {
        UserRepository.shared.reset()
        TransactionRepository.shared.reset()
        WalletRepository.shared.reset()
        AuthorizationRepository.shared.reset()
    }
}
