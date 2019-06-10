//
//  EnterPhoneNumberPresenterImpl.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class EnterPhoneNumberPresenterImpl: EnterPhoneNumberPresenter {
    typealias View = EnterPhoneNumberView

    weak var view: EnterPhoneNumberView? = nil

    private let tipApiService = TipApiService.sharedInstance

    func fetchCountryList() {
        tipApiService.getCountries { (countries, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.view?.onCountryListError(err: error)
                } else if let countries = countries {
                    self.view?.onCountryListFetched(countries)
                }
            }
        }
    }

    func validatePhoneNumber(_ verificationRequest: PhoneVerificationRequest) {
        if verificationRequest.countryCode.isEmpty || verificationRequest.phoneNumber.isEmpty {
            view?.onEmptyPhoneNumberError()
            return
        }
        if verificationRequest.phoneNumber.count < 5 {
            view?.onInvalidPhoneNumberError()
            return
        }

        tipApiService.startPhoneVerification(verificationRequest: verificationRequest) { (response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.view?.onVerificationError(err: error)
                } else {
                    self.view?.onVerificationStartedSuccessfully()
                }
            }
        }
    }

}
