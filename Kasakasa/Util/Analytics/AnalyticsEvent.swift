//
//  AnalyticsEvent.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-12-01.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

enum AnalyticsEvent: String {
    case tutorialStarted
    case tutorialEnded
    case enteredPhoneNumber
    case confirmedPhoneNumber
    case getRecoveryPhrase
    case confirmedRecoveryPhrase
    case savedPassword
    case signedUp

    case searchForContacts
    case addedContacts
    case viewdWalletList
    case selectedWallet
    case selectedTransaction
    case receiveTapped
    case sendTapped
    case sendTransferFilled
    case confirmTransferPasswordEntered
    case sendTransferSuccess
}
