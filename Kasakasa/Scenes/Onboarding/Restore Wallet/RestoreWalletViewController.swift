//
//  RestoreWalletViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class RestoreWalletViewController: BaseViewController {

    @IBOutlet weak var recoveryPhraseTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.endEditingOnTap = true
        self.navigationItem.title = "Enter Recovery Phrase"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
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

extension RestoreWalletViewController: UITextViewDelegate {
    
}
