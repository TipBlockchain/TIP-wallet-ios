//
//  TransactionSentViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-01.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class TransactionSentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func okayButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
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
