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

        self.endEditingOnTap = true
        self.navigationItem.title = "Verify Phone Number".localized
        presenter = VerifyPhoneNumberPresenterImpl()
        presenter?.attach(self)

        if phoneNumber == nil || countryCode == nil {
            showNoPhoneNumberProvidedError()
        }
    }

    @IBAction func verifyButtonTapped(_ sender: Any) {
        guard let phoneNumber = phoneNumber, let countryCode = countryCode else {
            showNoPhoneNumberProvidedError()
            return
        }
        guard let verificationCode = verificationCodeField.text, !verificationCode.isEmpty else {
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

    private func navigateToExistingAccount() {
        self.performSegue(withIdentifier: "ShowExistingAccount", sender: self)
    }
    
}

extension VerifyPhoneNumberViewController: VerifyPhoneNumberView {
    func onPhoneVerified(withExistingAccount account: User) {
        showToast("Phone number verified".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.navigateToExistingAccount()
        }
    }

    func onPhoneVerified(withPendingSignup signup: PendingSignup) {
        showToast("Phone number verified".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.navigateToRecoveryPhrase()
        }
    }

    func onPhoneVerified(withPendingSignup signup: PendingSignup, andDemoAccount account: User) {
        showToast("Phone number verified".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.navigateToExistingAccount()
        }
    }

    func onUnknownError(_ error: AppErrors) {
        showError(error)
    }

    func onPhoneVerificationError(_ error: AppErrors) {
        showError(error)
    }

}

extension VerifyPhoneNumberViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
