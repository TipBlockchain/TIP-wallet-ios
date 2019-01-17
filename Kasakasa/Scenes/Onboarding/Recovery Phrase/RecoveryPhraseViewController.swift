//
//  RecoveryPhraseViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class RecoveryPhraseViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Account Recovery Phrase".localized
        // Do any additional setup after loading the view.
    }
    
    @IBAction func recoveryPhraseButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowVerifyRecoveryPhrase", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
