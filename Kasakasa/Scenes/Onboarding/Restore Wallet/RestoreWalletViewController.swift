//
//  RestoreWalletViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class RestoreWalletViewController: BaseTableViewController {

    @IBOutlet private weak var recoveryPhraseTextView: UITextView!
    var existingUser: User?
    private var presenter: RestoreWalletPresenter?
    private var recoveryPhrase: String = ""
    private let maxCount = 160

    override func viewDidLoad() {
        super.viewDidLoad()

        self.endEditingOnTap = true
        self.navigationItem.title = "Enter Recovery Phrase"

        presenter = RestoreWalletPresenter()
        presenter?.attach(self)

        // Do any additional setup after loading the view.
    }

    @IBAction func pasteButtonTapped(_ sender: Any) {
        self.pasteClipboard(into: self.recoveryPhraseTextView)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.recoveryPhrase = recoveryPhraseTextView.text.trimmingCharacters(in: .newlines)
        presenter?.checkRecoveryPhrase(phrase: recoveryPhrase)
    }

    private func navigateToChoosePassword() {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "ChoosePasswordFromRestore", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChoosePasswordFromRestore", let vc = segue.destination as? ChoosePasswordViewController {
            vc.existingUser = self.existingUser
            vc.seedPhrase = self.recoveryPhrase
        }
    }
}

extension RestoreWalletViewController: RestoreWalletView {
    func onRecoveryPhraseVerified() {
        self.navigateToChoosePassword()
    }

    func onEmptyRecoveryPhrase() {
        showToast("Your recovery phrase can not be empty.".localized)
    }

    func onInvalidRecoveryPhraseLength() {
        showToast("Your recovery phrase is not the correct length.".localized)
    }

    func onInvalidRecoveryPhrase() {
        showToast("Your recovery phrase is invalid".localized)
    }

}

extension RestoreWalletViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }

        if range.length == 0, text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        return count <= maxCount
    }
}
