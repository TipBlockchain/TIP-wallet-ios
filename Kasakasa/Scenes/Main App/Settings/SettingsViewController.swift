//
//  SettingsViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class SettingsViewController: BaseTableViewController {

    @IBOutlet private var passwordSwitch: UISwitch!
    @IBOutlet private var recoveryPhraseSwitch: UISwitch!
    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var copyrightLabel: UILabel!
    private let defaults = AppDefaults.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.endEditingOnTap = false

        self.initUI()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            self.checkToShowRecoveryPhrase()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func initUI() {
        self.tableView.backgroundView = nil

        self.versionLabel.text = "Kasakasa v\(AppConfig.versionNumber) (\(AppConfig.buildNumber))"
        let year = Calendar.current.component(.year, from: Date())
        self.copyrightLabel.text = "Copyright © \(year) Tip Blockchain Network S.A."

        passwordSwitch.isOn = defaults.shouldPromptPasswordForTransactions
        recoveryPhraseSwitch.isOn = defaults.shouldPromptPasswordForRecoveryPhrase
    }

    private func checkToShowRecoveryPhrase() {
        if defaults.shouldPromptPasswordForRecoveryPhrase {
            self.showPasswordPromptAlert(withSuccess: {
                self.showBackupRecoveryPhrase()
            }, failure: nil)
        } else {
            self.showBackupRecoveryPhrase()
        }
    }
    private func showBackupRecoveryPhrase() {
        self.performSegue(withIdentifier: "ShowBackupRecoveryPhrase", sender: self)
    }

    @IBAction private func passwordSwitchValueChanged(_ sender: UISwitch) {
        let newValue = sender.isOn
        if newValue == false {
            self.showPasswordPromptAlert(withSuccess: {
                self.defaults.shouldPromptPasswordForTransactions = false
            }) {
                sender.isOn = true
            }
        } else {
            self.defaults.shouldPromptPasswordForTransactions = true
        }
    }

    @IBAction private func recoveryPhraseValueChanged(_ sender: UISwitch) {
        let newValue = sender.isOn
        if newValue == false {
            self.showPasswordPromptAlert(withSuccess: {
                self.defaults.shouldPromptPasswordForRecoveryPhrase = false
            }) {
                sender.isOn = true
            }
        } else {
            self.defaults.shouldPromptPasswordForRecoveryPhrase = true
        }
    }

    private func showPasswordPromptAlert(withSuccess successBlock: @escaping VoidClosure, failure failureBlock: VoidClosure? = nil) {
        do {
            let passwordInKeychain = try TipKeychain.readPassword()
            self.showTextFieldAlert(withTitle: "Enter your password".localized, message: "Your password is required to perform this action.", style: .alert, isSecure: true, onOkSelected: { (password) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                    if password == passwordInKeychain {
                        successBlock()
                    } else {
                        self.showError(withTitle: "Wrong password".localized, message: "The password you entered is not correct. Please try again.".localized)
                        failureBlock?()
                    }
                })
            }, onCancelSelected: {
                failureBlock?()
            })
        } catch {
            self.showError(AppErrors.error(error: error))
        }
    }
}
