//
//  BackupRecoveryPhraseViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class BackupRecoveryPhraseViewController: BaseViewController {

    @IBOutlet private var recoveryPhraseTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.readRecoveryPhrase()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func copyTapped(_ sender: Any) {
        self.copyToClipboard(self.recoveryPhraseTextView.text)
    }

    @IBAction func backupNowTapped(_ sender: Any) {
        let text = self.recoveryPhraseTextView.text ?? ""
        self.startShareActivity(text)
    }

    private func readRecoveryPhrase() {
        do {
            let recoveryPhrase = try TipKeychain.readRecoveryPhrase()
            self.recoveryPhraseTextView.text = recoveryPhrase
        } catch {
            self.showError(AppErrors.error(error: error))
        }
    }
}
