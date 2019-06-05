//
//  TradeTipViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class TradeTipViewController: BaseViewController {

    @IBOutlet private var tableView: UITableView!

    private var exchanges: [CryptoExchange] = []
    private let cellIdentifier = "CryptoExchangeCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.exchanges = AppConfig.exchanges ?? []
        tableView.reloadData()
    }

    private func launchExchange(_ exchange: CryptoExchange) {
        debugPrint("Opening exchange: \(exchange)")
        if let url = URL(string: exchange.url) {
            self.openUrl(url)
        }
    }

    private func exchange(atIndexPath indexPath: IndexPath) -> CryptoExchange? {
        if exchanges.count > indexPath.row {
            return exchanges[indexPath.row]
        }
        return nil
    }
}

extension TradeTipViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchanges.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CryptoExchangeTableViewCell
        if let exchange = self.exchange(atIndexPath: indexPath) {
            cell.exchange = exchange
        }
        return cell
    }
}

extension TradeTipViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let exchange = self.exchange(atIndexPath: indexPath) {
            self.showOkCancelAlert(withTitle: String(format: "Go to %@", exchange.name), message: String(format: "Do you want to open %@ in your web browser?", exchange.name), style: .alert, onOkSelected: {
                self.launchExchange(exchange)
                tableView.deselectRow(at: indexPath, animated: true)
            }, onCancelSelected: {
                tableView.deselectRow(at: indexPath, animated: true)
            })
        } else {
            self.showError(withTitle: "Error openeing exchange", message: "Unable to open excahnege url.")
        }
    }
}
