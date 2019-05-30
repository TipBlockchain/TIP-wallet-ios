//
//  SendTransferViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-14.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class SendTransferViewController: BaseViewController {

    var targetUser: User?

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var currencyPickerView: UIPickerView!

    @IBOutlet private weak var currencyField: UITextField?
    @IBOutlet private weak var availableFundsField: UITextField?
    @IBOutlet private weak var recepientField: UITextField?
    @IBOutlet private weak var amountField: UITextField?

    @IBOutlet private weak var networkFeeLabel: UILabel?
    @IBOutlet private weak var networkFeeSlider: UISlider?
    @IBOutlet private weak var pickerView: UIPickerView?
    @IBOutlet private weak var toolbar: UIToolbar!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!

    private var presenter: SendTransferPresenter?
    private var contactList: [User] = []

    private let tagNetworkFeeLabel = 101
    private var selectedCurrency: Currency?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.leftItemsSupplementBackButton = true
        self.setupPresenter()
        self.setupForm()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavigationBarTransparent()
    }

    private func setupForm() {

    }

    private func setupPresenter() {
        presenter = SendTransferPresenter()
        presenter?.attach(self)
        presenter?.loadContactList()
        presenter?.loadWallets()
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowConfirmTransfer", sender: self)
    }

    @IBAction func toolbarSaveButtonTapped(_ sender: Any) {
        self.currencyField?.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction @objc func sliderValueChanged(_ sender: UISlider) {
        self.networkFeeLabel?.text = String.init(format: "Network Fee: %.0f", sender.value.rounded(.toNearestOrAwayFromZero))
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
        self.setOutlet(forCell: cell, atIndexPath: indexPath)
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

    private enum CellIndex: Int {
        case currency = 0
        case availableFunds
        case recepient
        case amount
        case networkFee
    }

    private func setOutlet(forCell cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case CellIndex.currency.rawValue:
            self.currencyField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
            self.currencyField?.inputView = self.pickerView
            self.currencyField?.inputAccessoryView = self.toolbar
        case CellIndex.availableFunds.rawValue:
            self.availableFundsField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
        case CellIndex.recepient.rawValue:
            self.recepientField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
        case CellIndex.amount.rawValue:
            self.amountField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
        case CellIndex.networkFee.rawValue:
            self.networkFeeSlider = cell.contentView.subView(ofType: UISlider.self) as? UISlider
            self.networkFeeLabel = cell.contentView.viewWithTag(tagNetworkFeeLabel) as? UILabel
            self.networkFeeSlider?.isContinuous = true
            self.networkFeeSlider?.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        default:
            break
        }
    }

    private func currencySelected(_ currency: Currency) {
        self.selectedCurrency = currency
    }
}

extension SendTransferViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if identifier(forIndexPath: indexPath) == .NetworkFeeCell {
            return 120
        }
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if identifier(forIndexPath: indexPath) == .RecepientCell {
            self.performSegue(withIdentifier: "ShowSelectContact", sender: self)
        }
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
        self.currencyField?.text = selectedCurrency?.rawValue
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

extension SendTransferViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {

    }
}
