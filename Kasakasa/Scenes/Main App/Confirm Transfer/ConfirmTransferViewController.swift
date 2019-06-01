//
//  ConfirmTransferViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-14.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import BigInt
import web3swift

class ConfirmTransferViewController: BaseViewController {

    @IBOutlet private var tableView: UITableView!

    @IBOutlet private weak var toField: UITextField?
    @IBOutlet private weak var fromField: UITextField?
    @IBOutlet private weak var amountField: UITextField?
    @IBOutlet private weak var networkFeeField: UITextField?
    @IBOutlet private weak var totalField: UITextField?

    var pendingTransaction: PendingTransaction?
    var txFee: BigUInt = BigUInt("0")
    var gasPrice: BigUInt? = nil

    private let decimals = 5
    private var presenter: ConfirmTransferPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = ConfirmTransferPresenter()
        presenter?.attach(self)

        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
    }

    deinit {
        presenter?.detach()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setFieldValues()
    }
    
    @IBAction func sendTransferTapped(_ sender: Any) {
        self.showTextFieldAlert(withTitle: "Enter  your password",
                                message: "Enter your password to unlock your wallet and send this transcation.".localized,
                                style: .alert,
                                isSecure: true,
                                onOkSelected: { password in
                                    self.sendTransaction(withPassword: password ?? "")
        })
    }

    private func setFieldValues() {
        if let transaction = self.pendingTransaction {
            self.toField?.text = transaction.toUsername ?? transaction.to
            self.fromField?.text = transaction.fromUsername ?? transaction.from

            let txValueString = EthConvert.toEthereumUnits(transaction.value, decimals: decimals) ?? "0"
            self.amountField?.text = String(format: "%@ %@",  txValueString, transaction.currency.rawValue)

            let txFeeString = EthConvert.toEthereumUnits(txFee, decimals: decimals) ?? "0"
            self.networkFeeField?.text = String(format: "%@ %@", txFeeString, Currency.ETH.rawValue)

            if pendingTransaction?.currency == .TIP {
                self.totalField?.text = String(format: "%@ %@ + %@ %@", txValueString, transaction.currency.rawValue, txFeeString, Currency.ETH.rawValue)
            } else if pendingTransaction?.currency == .ETH {
                let txTotalInWal = transaction.value + txFee
                let txTotalValueString = EthConvert.toEthereumUnits(txTotalInWal, decimals: decimals) ?? "0"
                self.totalField?.text = String(format: "%@ %@", txTotalValueString, transaction.currency.rawValue)
            }
        }
    }

    func onTransactionSent() {
        debugPrint("tx sent")
        self.performSegue(withIdentifier: "ShowTransferSent", sender: self)
    }

    func onTransactionError(_ error: AppErrors) {
        self.showError(error)
    }

    private func sendTransaction(withPassword password: String) {
        guard let pendingTransaction = self.pendingTransaction else {
            showError(AppErrors.genericError(message: "Invalid transaction. Please try again.".localized)) {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        guard let gasPrice = self.gasPrice else {
            showError(AppErrors.genericError(message: "Failed to set the gas price correctly. Please try again.".localized)) {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        debugPrint("seding tx with gasPrice = \(String(gasPrice))")
        presenter?.sendTransaction(pendingTransaction, password: password, gasPrice: gasPrice)
    }

    private enum  ConfirmTransferCell: String {
        case toCell, fromCell, amountCell, networkFeeCell, totalCell, none
    }
}

extension ConfirmTransferViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(forIndexPath: indexPath).rawValue, for: indexPath)
        self.setOutlet(forCell: cell, atIndexPath: indexPath)
        return cell
    }

    private func cellIdentifier(forIndexPath indexPath: IndexPath) -> ConfirmTransferCell {
        switch indexPath.row {
        case 0:
            return .toCell
        case 1:
            return .fromCell
        case 2:
            return .amountCell
        case 3:
            return .networkFeeCell
        case 4:
            return .totalCell
        default:
            return .none
        }
    }

    private enum CellIndex: Int {
        case to = 0
        case from
        case amount
        case networkFee
        case total
    }

    private func setOutlet(forCell cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case CellIndex.to.rawValue:
            self.toField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
        case CellIndex.from.rawValue:
            self.fromField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
        case CellIndex.amount.rawValue:
            self.amountField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
        case CellIndex.networkFee.rawValue:
            self.networkFeeField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
        case CellIndex.total.rawValue:
            self.totalField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
        default:
            break
        }
    }

}
