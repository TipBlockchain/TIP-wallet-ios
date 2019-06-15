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
    private lazy var presenter = WalletPresenter()
    private lazy var walletRepo = WalletRepository.shared
    private var transactions: [Transaction] = []
    private var selectedTransaction: Transaction?

    var wallet: Wallet?
    private let transactionCellIdentifier = "TransactionCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showEmptyView(false)
        tableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: transactionCellIdentifier)
        tableView.tableFooterView = UIView()
        self.navigationItem.backBarButtonItem?.title = ""

        presenter.attach(self)
        if let wallet = self.wallet {
            presenter.getBalance(forWallet: wallet)
        }
        self.currencyLabel.text = wallet?.currency.rawValue ?? ""

    }

    deinit {
        presenter.detach()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarTransparent()
        self.navigationItem.backBarButtonItem?.title = ""

//        self.navigationBarHiddenState = self.navigationController?.isNavigationBarHidden ?? false
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
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

    func onBalanceFetched(_ balance: String) {
        debugPrint("Balance = \(balance)")
        balanceLabel.text = balance
    }

    func onTransactionsFetched(_ transactions: [Transaction]) {
        self.showEmptyView(transactions.isEmpty)
        self.transactions = transactions
        tableView.reloadData()
    }

    func onTransactionFetchError(_ error: AppErrors) {
        self.showError(error)
    }

    func onNoTransactionsFound() {
        // show no transactions view
        self.showEmptyView(true)
    }

    private func showTransactionDetails(_ transaction: Transaction) {
        self.selectedTransaction = transaction
        self.performSegue(withIdentifier: "ShowTransactionDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTransactionDetails", let destination = segue.destination as? TransactionDetailsViewController {
            destination.transaction = self.selectedTransaction
        }
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
