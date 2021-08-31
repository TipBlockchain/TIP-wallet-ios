//
//  WalletListViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class WalletListViewController: BaseViewController {

    @IBOutlet private weak var tableView : UITableView!
    private var wallets: [Wallet] = []
    private let cellIdentifier = "WalletListCell"
    private var presenter: WalletListPresenter?
    private var selectedWallet: Wallet?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        presenter = WalletListPresenter()
        presenter?.attach(self)
        presenter?.loadWallets()
    }

    deinit {
        presenter?.detach()
        presenter = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setRegularNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkForWalletBalances()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWallet", let destination = segue.destination as? WalletViewController {
            destination.wallet = self.selectedWallet
        }
    }

    func onWalletsLoaded(_ wallets: [Wallet]) {
        self.wallets = wallets
        self.tableView.reloadData()
    }

    func onWalletLoadError(_ error: AppErrors) {
        self.showError(error)
    }

    private func showWallet() {
        self.performSegue(withIdentifier: "ShowWallet", sender: self)
    }

    private func checkForWalletBalances() {
        self.presenter?.checkForBalanceUpdates(inWallets: wallets)
    }
}

extension WalletListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WallletListCell", for: indexPath) as! WalletListTableViewCell
        if let wallet = self.wallet(atIndexPath: indexPath) {
            cell.wallet = wallet
        }
        return cell
    }

    func wallet(atIndexPath indexPath: IndexPath) -> Wallet? {
        if wallets.count > indexPath.row {
            return wallets[indexPath.row]
        }
        return nil
    }
}

extension WalletListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wallet = self.wallet(atIndexPath: indexPath) {
            self.selectedWallet = wallet
            self.showWallet()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

