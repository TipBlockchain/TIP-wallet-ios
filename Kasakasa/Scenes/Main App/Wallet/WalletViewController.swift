//
//  WalletViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-08.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class WalletViewController: BaseViewController {

    private var navigationBarHiddenState: Bool = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true

//        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarHiddenState = self.navigationController?.isNavigationBarHidden ?? false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(navigationBarHiddenState, animated: true)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
    }
    @IBAction func receiveButtonTapped(_ sender: Any) {
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
