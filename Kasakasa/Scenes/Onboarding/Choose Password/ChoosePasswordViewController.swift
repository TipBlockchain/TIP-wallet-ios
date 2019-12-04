//
//  ChoosePasswordViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class ChoosePasswordViewController: BaseTableViewController {

    var seedPhrase: String = ""
    var password: String  = ""
    var password2: String = ""

    var existingUser: User?
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var confirmPasswordField: UITextField?
    @IBOutlet private weak var promptTextLabel: UILabel!
    @IBOutlet private weak var savePasswordLabel: UILabel!
    @IBOutlet private weak var savePasswordSwitch: UISwitch!

    private var presenter: ChoosePasswordPresenter?
    private var isPasswordSaved = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.endEditingOnTap = true
        self.navigationItem.title = "Account Password".localized
        if self.existingUser != nil {
            self.promptTextLabel.text = "Enter your password.\nYou must enter the same password you used when you crearted your account.".localized

            self.isPasswordSaved = true
            self.savePasswordLabel.isHidden = true
            self.savePasswordSwitch.isHidden = true
        }

        self.setupPresenter()
    }

    private func setupPresenter() {
        presenter = ChoosePasswordPresenter()
        presenter?.attach(self)
        presenter?.setExistingUser(self.existingUser)
    }

    deinit {
        presenter?.detach()
        presenter = nil
    }

    @IBAction func savePasswordTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.password = self.passwordField.text ?? ""
        self.password2 = self.confirmPasswordField?.text ?? ""

        guard self.password.isValidPassword() else {
              showToast("Password must be at least 8 characters long".localized)
              return
        }

        if self.existingUser == nil && password == password2 { // can't use guard
            showToast("Passwords do not match".localized)
            return
        }

        guard isPasswordSaved else {
            showToast("Please make sure you have saved your password before you continue.".localized)
            return
        }

        presenter?.generateWallet(fromSeedPhrase: seedPhrase, andPassword: password)
    }

    @IBAction func passwordSavedSwitched(_ sender: UISwitch) {
        isPasswordSaved = sender.isOn
    }

    private func navigateToUserProfile() {
        self.performSegue(withIdentifier: "ShowOnboardingUserProfile", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension ChoosePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension ChoosePasswordViewController: ChoosePasswordView {
    func onWalletCreated() {
        AppAnalytics.logEvent(.savedPassword)
        
        showToast("Wallet created".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.navigateToUserProfile()
        }
    }

    func onWalletRestored() {
        AppAnalytics.logEvent(.savedPassword)

        self.showOkAlert(withTitle: "Hoorah!".localized, message: "Your wallets have been restored on this device. Happy Tipping!".localized, style: .alert) {
            self.navigateToMainApp()
        }
    }

    func onWalletNotMatchingExistingError() {
        let error = AppErrors.genericError(message: "The restored wallet address does not match the address for \(self.existingUser?.username ?? "this user"). Please enter the same recovery phrase and password used to create the account.".localized)
        showError(error)
    }

    func onWalletCreationError(_ error: AppErrors) {
        self.showError(error)
    }

}
