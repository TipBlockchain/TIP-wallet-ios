//
//  EnterPhoneNumber.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol EnterPhoneNumberView: class, BaseView {
    func onCountryListFetched(_ countries: [Country])
    func onCountryListError(err: AppErrors)
    func onEmptyPhoneNumberError()
    func onInvalidPhoneNumberError()
    func onVerificationError(err: AppErrors)
    func onVerificationStartedSuccessfully()
}

protocol EnterPhoneNumberPresenter: BasePresenter {
    func fetchCountryList()
    func validatePhoneNumber(_ request: PhoneVerificationRequest)
}
