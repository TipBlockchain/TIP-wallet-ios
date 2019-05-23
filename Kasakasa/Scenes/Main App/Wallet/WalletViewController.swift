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
    private var transactionProcessor: ChainProcessor?
    private lazy var presenter = WalletPresenter()
    private lazy var walletRepo = WalletRepository.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attach(self)
        self.navigationController?.isNavigationBarHidden = true
        if let wallets = walletRepo.allWallets() {
            let firstWallet = wallets[1]
            presenter.getBalance(forWallet: firstWallet)
        }


//        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter.detach()
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

    func onBalanceFetchError(_ error: AppErrors) {
        self.showToast("Error fetching account balance: \(error.message)")
    }

    func onBalanceFetched(_ balance: NSDecimalNumber) {
        showToast("Balance = \(balance)")
        debugPrint("Balance = \(balance)")
        balanceLabel.text = balance.description(withLocale: Locale.current)
    }

}
