//
//  SendTransferViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-14.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SendTransferViewController: BaseViewController {

    var targetUser: User?

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var currencyPickerView: UIPickerView!

    @IBOutlet private weak var curencyField: SkyFloatingLabelTextField!
    @IBOutlet private weak var availableFundsField: SkyFloatingLabelTextField!
    @IBOutlet private weak var recepientField: SkyFloatingLabelTextField!
    @IBOutlet private weak var amountField: SkyFloatingLabelTextField!

    @IBOutlet private weak var networkFeeLabel: UILabel!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!

    private var presenter: SendTransferPresenter?
    private var contactList: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.leftItemsSupplementBackButton = true
        self.setupPresenter()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavigationBarTransparent()
    }
    
    private func setupPresenter() {
        presenter = SendTransferPresenter()
        presenter?.attach(self)
        presenter?.loadContactList()
        presenter?.loadWallets()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func sliderValueChanged(_ sender: Any) {
    }
    private enum SendTransferCell: String {
        case SelectCurrencyCell, CurrencyPickerCell, AvailableFundsCell, RecepientCell, AmountCell, NetworkFeeCell, NoCell
    }

}

extension SendTransferViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = self.identifier(forIndexPath: indexPath).rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }

    private func identifier(forIndexPath indexPath: IndexPath) -> SendTransferCell {
        switch indexPath.row {
        case 0:
            return .SelectCurrencyCell
        case 1:
            return .AvailableFundsCell
        case 2:
            return .RecepientCell
        case 3:
            return .AmountCell
        case 4:
            return .NetworkFeeCell
        default:
            return .NoCell
        }
    }

    private func currencySelected(_ currency: Currency) {

    }
}

extension SendTransferViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 94
        }
        return 60
    }
}

extension SendTransferViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            self.currencySelected(.TIP)
        case 1:
            self.currencySelected(.ETH)
        default:
            break
        }
    }
}


extension SendTransferViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return Currency.TIP.rawValue
        case 1:
            return Currency.ETH.rawValue
        default:
            return nil
        }
    }
}

extension SendTransferViewController: SendTransferView {

    func onContactsFetched(_ contacts: [User]) {
        self.contactList = contacts
        debugPrint("Conacts are: \(contacts)")
    }

    func onUserNotFound(_ username: String) {
    }

    func onInvalidRecipient() {
    }

    func onInsufficientEthBalanceError() {
    }

    func onInsufficientTipBalanceError() {
    }

    func onInvalidTransactionValueError() {
    }

    func onWalletError() {
        debugPrint("Error loading wallet:")
    }

    func onSendPendingTransaction(_ tx: PendingTransaction) {
    }

    func onBalanceFetched(_ balance: NSDecimalNumber, forCurrency currency: Currency) {
        debugPrint("Balance fetched: \(balance)")
    }

    func onBalanceFetchError(_ error: AppErrors) {
        self.showError(error)
    }

    func onContactsFetchError(error: AppErrors) {
        debugPrint("Error fetching contacts: \(error)")
        self.showError(error)
    }

    func onTransactionFeeCalculated(feeInEth: Double, gasPriceInGwei: Int) {
    }


}
