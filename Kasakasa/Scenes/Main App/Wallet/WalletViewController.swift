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
    private var transactions: [Transaction] = []
    private var wallet: Wallet? {
        didSet {
            self.currencyLabel.text = wallet?.currency.rawValue ?? ""
        }
    }
    private let transactionCellIdentifier = "TransactionCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: transactionCellIdentifier)
        tableView.tableFooterView = UIView()

        presenter.attach(self)
        self.navigationController?.isNavigationBarHidden = true
        if let wallets = walletRepo.allWallets() {
            self.wallet = wallets[0]
            presenter.getBalance(forWallet: wallet!)
        }
    }

    deinit {
        presenter.detach()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarHiddenState = self.navigationController?.isNavigationBarHidden ?? false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.fetchTransactions(forWallet: self.wallet!)
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
        debugPrint("Balance = \(balance)")
        balanceLabel.text = balance.description(withLocale: Locale.current)
    }

    func onTransactionsFetched(_ transactions: [Transaction]) {
        self.transactions = transactions
        tableView.reloadData()
    }

    func onTransactionFetchError(_ error: AppErrors) {
        self.showError(error)
    }

    func onNoTransactionsFound() {
        // show no transactions view
    }

    private func showTransactionDetails(_ transaction: Transaction) {

    }
}


extension WalletViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: transactionCellIdentifier) as! TransactionTableViewCell
        if let transaction = self.transaction(atIndexPath: indexPath) {
            cell.wallet = self.wallet
            cell.transaction = transaction
        }
        return cell
    }

    private func transaction(atIndexPath indexPath: IndexPath) -> Transaction? {
        if self.transactions.count > indexPath.row {
            return self.transactions[indexPath.row]
        }
        return nil
    }

}

extension WalletViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let transaction = self.transaction(atIndexPath: indexPath) {
            self.showTransactionDetails(transaction)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30.0
//    }
}
