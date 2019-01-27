//
//  RecoveryPhraseViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class RecoveryPhraseViewController: BaseViewController {

    @IBOutlet private weak var recoveryPhraseTextView: UITextView!
    private var presenter: RecoveryPhrasePresenter?
    private var isRecoveryPhraseSaved = false
    private var recoveryPhrase: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = RecoveryPhrasePresenter()
        presenter?.attach(self)
        presenter?.getNewMnemonic()

        self.navigationItem.title = "Account Recovery Phrase".localized
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter?.detach()
        presenter = nil
    }
    
    @IBAction func recoveryPhraseButtonTapped(_ sender: Any) {
        if isRecoveryPhraseSaved {
            self.performSegue(withIdentifier: "ShowVerifyRecoveryPhrase", sender: self)
        } else {
            self.showToast("Recovery phrase must be saved before continuing.".localized)
        }
    }

    @IBAction func copyToClipboardTapped(_ sender: Any) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = recoveryPhraseTextView.text
        showToast("Recovery phrase copied".localized)
    }
    
    @IBAction func recoverySavedSwitched(_ sender: UISwitch) {
        isRecoveryPhraseSaved = sender.isOn
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVerifyRecoveryPhrase",
            let recoveryPhrase = recoveryPhrase,
            let destinationController = segue.destination as? VerifyRecoveryPhraseViewController {
            destinationController.recoveryPhrase = recoveryPhrase
        }
    }
}

extension RecoveryPhraseViewController: RecoveryPhraseView {
    func onRecoveryPhraseCreated(_ phrase: String) {
        self.recoveryPhrase = phrase
        recoveryPhraseTextView.text = phrase
    }

    func onError(_ error: AppErrors) {
        showError(error)
    }
}
