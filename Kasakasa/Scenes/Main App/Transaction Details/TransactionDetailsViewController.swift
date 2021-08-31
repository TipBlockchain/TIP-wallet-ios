//
//  TransactionDetailsViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-11.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

struct TransactionDetail {
    var title: String
    var details: String
}
class TransactionDetailsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let cellIdentifier = "TransactionDetailsCell"
    var transaction: Transaction?
    var details: [TransactionDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()

        self.setDetails()
        // Do any additional setup after loading the view.
    }

    func setDetails() {
        if let tx = self.transaction {
            self.details = [
                TransactionDetail(title: "From", details: tx.from),
                TransactionDetail(title: "To", details: tx.to),
                TransactionDetail(title: "Value", details: EthConvert.toEthereumUnits(tx.value, decimals: 4) ?? "0.00"),
                TransactionDetail(title: "Time", details: DateFormatter.displayDateFormatter.string(from: tx.timestamp)),
                TransactionDetail(title: "Transaction Hash", details: tx.hash),
                TransactionDetail(title: "Block Hash", details: tx.blockHash ?? ""),
                TransactionDetail(title: "Confirmations", details: String(tx.confirmations)),
                TransactionDetail(title: "Nonce", details: "\(tx.nonce ?? 0)"),
            ]
            tableView.reloadData()
        }
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

extension TransactionDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if details.count > indexPath.row {
            let detail = details[indexPath.row]
            cell.textLabel?.text = detail.title
            cell.detailTextLabel?.text = detail.details
        }
        return cell
    }
}

extension TransactionDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if details.count > indexPath.row {
            let detail = details[indexPath.row]
            self.copyToClipboard(detail.details)
            self.showToast("\(detail.title) copied")
        }
    }
}
