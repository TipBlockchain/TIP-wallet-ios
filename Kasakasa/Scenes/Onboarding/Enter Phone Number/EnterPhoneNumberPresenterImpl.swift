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

    var view: EnterPhoneNumberView? = nil

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

    func validatePhoneNumber(_ request: PhoneVerificationRequest) {

    }

}
