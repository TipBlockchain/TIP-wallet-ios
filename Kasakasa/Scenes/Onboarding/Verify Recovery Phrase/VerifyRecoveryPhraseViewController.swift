//
//  VerifyRecoveryPhraseViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class VerifyRecoveryPhraseViewController: BaseTableViewController {

    @IBOutlet weak var recoveryPhraseTextView: UITextView!
    @IBOutlet weak var firstWordTextField: UITextField!
    @IBOutlet weak var secondWordTextField: UITextField!

    var recoveryPhrase: String = ""
    private var modifiedrecoveryPhrase: String = ""
    private var presenter: VerifyRecoveryPhrasePresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.endEditingOnTap = true
        self.navigationItem.title = "Verify Recovery Phrase".localized

        setupPresenter()
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter?.detach()
        presenter = nil
    }

    private func setupPresenter() {
        presenter = VerifyRecoveryPhrasePresenter()
        presenter?.attach(self)
        presenter?.setRecoveryPhrase(recoveryPhrase)
        presenter?.removeWords()
    }

    @IBAction func verifyRecoveryButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            if let firstWord = self.firstWordTextField.text, let secondWord = self.secondWordTextField.text,
                !firstWord.isEmpty, !secondWord.isEmpty {
                self.presenter?.verifyRecoveryPhrase(self.modifiedrecoveryPhrase, word1: firstWord, word2: secondWord)
            } else {
                self.showToast("Please enter the missing words in the text fields.".localized)
            }
        }
    }

    // MARK: - Navigation

    private func navigateToChoosePassword() {
        self.performSegue(withIdentifier: "ShowChoosePassword", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChoosePassword" {
            if let choosePasswordVc = segue.destination as? ChoosePasswordViewController {
                choosePasswordVc.seedPhrase = recoveryPhrase
            }
        }
    }
}

extension VerifyRecoveryPhraseViewController: VerifyRecoveryPhraseView {
    
    func onWordsRemoved(phrase: String, firstIndex: Int, secondIndex: Int) {
        modifiedrecoveryPhrase = phrase
        recoveryPhraseTextView.text = modifiedrecoveryPhrase
    }

    func onPhraseVerified() {
        showToast("Recovery phrase verified".localized)
        AppAnalytics.logEvent(.confirmedRecoveryPhrase)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.navigateToChoosePassword()
        }
    }

    func onVerificationError() {
        showError(AppErrors.genericError(message: "Incorrect words entered. Please make sure you have saved your recovery phrase.".localized))
    }
}

extension VerifyRecoveryPhraseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension VerifyRecoveryPhraseViewController: UITextViewDelegate {
    
}
