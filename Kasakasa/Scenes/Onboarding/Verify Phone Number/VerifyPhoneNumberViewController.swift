//
//  VerifyPhoneNumberViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class VerifyPhoneNumberViewController: BaseViewController {

    typealias View = VerifyPhoneNumberView

    public var countryCode: String?
    public var phoneNumber: String?

    private var presenter: VerifyPhoneNumberPresenterImpl?
    @IBOutlet private var verificationCodeField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Verify Phone Number".localized
        presenter = VerifyPhoneNumberPresenterImpl()
        presenter?.attach(self)

        if phoneNumber == nil || countryCode == nil {
            showNoPhoneNumberProvidedError()
        }
    }

    @IBAction func verifyButtonTapped(_ sender: Any) {
        self.navigateToRecoveryPhrase()
        return
        
        guard let phoneNumber = phoneNumber, let countryCode = countryCode else {
            showNoPhoneNumberProvidedError()
            return
        }
        guard let verificationCode = verificationCodeField.text else {
            showError(AppErrors.genericError(message: "Verification code must be provided".localized))
            return
        }

        let verificationRequest = PhoneVerificationRequest(countryCode: countryCode, phoneNumber: phoneNumber, verificationCode: verificationCode)
        presenter?.verifyPhoneNumber(verificationRequest)
    }

    private func showNoPhoneNumberProvidedError() {
        self.showError(AppErrors.genericError(message: "No phone number provided".localized)) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func navigateToRecoveryPhrase() {
        self.performSegue(withIdentifier: "ShowRecoveryPhrase", sender: self)
    }
    
}

extension VerifyPhoneNumberViewController: VerifyPhoneNumberView {
    func onPhoneVerifiedWithExistingAccount(_: User) {
    }

    func onPhoneVerifiedWithPendingAccount(_: User) {
    }

    func onPhoneVerifiedWithPendingAndDemoAccount(pendingAccount: User, demoAccount: User) {
    }

    func onUnknownError(err: AppErrors) {
    }

    func onPhoneVerificationError(error: AppErrors) {
    }


}
