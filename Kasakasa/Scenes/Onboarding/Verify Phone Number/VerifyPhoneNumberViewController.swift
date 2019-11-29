//
//  VerifyPhoneNumberViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class VerifyPhoneNumberViewController: BaseTableViewController {

    typealias View = VerifyPhoneNumberView

    public var countryCode: String?
    public var phoneNumber: String?

    private var demoAccount: User?
    private var existingAccount: User?

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.enableInteraction(true)
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

        self.enableInteraction(false)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExistingAccount", let viewController = segue.destination as? ExistingAccountViewController {
            viewController.existingUser = self.existingAccount
            viewController.demoAccountUser = self.demoAccount
        }
    }

    private func enableInteraction(_ enable: Bool) {
        self.view.endEditing(true)
        self.navigationItem.rightBarButtonItem?.isEnabled = enable
    }
    
}

extension VerifyPhoneNumberViewController: VerifyPhoneNumberView {

    func onPhoneVerified(withExistingAccount account: User) {
        showToast("Phone number verified".localized)
        self.existingAccount = account
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.navigateToExistingAccount()
        }
    }

    func onPhoneVerified(withPendingSignup signup: PendingSignup) {
        showToast("Phone number verified".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.navigateToRecoveryPhrase()
        }
    }

    func onPhoneVerified(withPendingSignup signup: PendingSignup, andDemoAccount account: User) {
        showToast("Phone number verified".localized)
        self.demoAccount = account
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.navigateToExistingAccount()
        }
    }

    func onUnknownError(_ error: AppErrors) {
        showError(error)
        self.enableInteraction(true)
    }

    func onPhoneVerificationError(_ error: AppErrors) {
        showError(error)
        self.enableInteraction(true)
    }

}

extension VerifyPhoneNumberViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
