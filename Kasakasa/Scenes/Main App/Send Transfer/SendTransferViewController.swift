//
//  SendTransferViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-14.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import BigInt

class SendTransferViewController: BaseViewController {

    var targetUser: User?
    var targetAddress: String?
    var targetAddressOrUsername: String {
        if let user = self.targetUser {
            return user.username
        } else if let address = self.targetAddress {
            return address
        }
        return ""
    }

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
    private let defaultGasPrice: Float = 11.0
    private var gasPrice: Float = 11.0

    private var selectedCurrency: Currency = .TIP
    private var pendingTransaction: PendingTransaction? = nil
    private var txFeeInWei: BigUInt = BigUInt("0")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.leftItemsSupplementBackButton = true
        self.setupPresenter()
        self.setupForm()
//        self.endEditingOnTap = true
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
        presenter?.loadWallets()
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.presenter?.validateTransfer(usernameOrAddress: self.targetAddressOrUsername, value: NSDecimalNumber(string: amountField?.text), txFeeInWei:self.txFeeInWei, currency: selectedCurrency, message: nil)
    }

    @IBAction func toolbarSaveButtonTapped(_ sender: Any) {
//        self.currencyField?.resignFirstResponder()
        self.view.endEditing(true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSelectContact", let selectVC = segue.destination as? SelectContactViewController {
            selectVC.delegate = self
        } else if segue.identifier == "ShowConfirmTransfer", let confirmVC = segue.destination as? ConfirmTransferViewController {
            let gasPriceInWei = EthConvert.toWei(BigUInt(integerLiteral: UInt64(gasPrice.rounded(.toNearestOrEven))), fromUnit: .gwei)

            confirmVC.pendingTransaction = self.pendingTransaction
            confirmVC.txFee = self.txFeeInWei
            confirmVC.gasPrice = gasPriceInWei
        }
    }

    @IBAction @objc func sliderValueChanged(_ sender: UISlider) {
        self.gasPrice = sender.value
        presenter?.calculateTransactionFee(gasPrice: self.gasPrice)
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
            self.recepientField?.text = self.targetUser?.username ?? ""
        case CellIndex.amount.rawValue:
            self.amountField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
            self.amountField?.inputAccessoryView = self.toolbar
        case CellIndex.networkFee.rawValue:
            self.networkFeeSlider = cell.contentView.subView(ofType: UISlider.self) as? UISlider
            self.networkFeeLabel = cell.contentView.viewWithTag(tagNetworkFeeLabel) as? UILabel
            self.networkFeeSlider?.isContinuous = true
            self.networkFeeSlider?.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            self.networkFeeSlider?.setValue(self.defaultGasPrice, animated: false)
            presenter?.calculateTransactionFee(gasPrice: self.defaultGasPrice)
        default:
            break
        }
    }

    private func currencySelected(_ currency: Currency) {
        self.selectedCurrency = currency
        self.currencyField?.text = currency.rawValue
        presenter?.currencySelected(currency)
    }

    private func updateNetworkFeeLabel(_ feeInEth: String, gasPrice: Float) {
        self.networkFeeLabel?.text = String.init(format: "Network Fee: %@ ETH (%.0f GWEI)", feeInEth, gasPrice.rounded(.toNearestOrAwayFromZero))
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
        if identifier(forIndexPath: indexPath) == .CurrencyPickerCell {
            self.currencyField?.becomeFirstResponder()
        } else if identifier(forIndexPath: indexPath) == .RecepientCell {
            self.performSegue(withIdentifier: "ShowSelectContact", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SendTransferViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }

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
        self.showError(AppErrors.genericError(message: "No user with username \(username) in your contacts".localized))
    }

    func onInvalidRecipient() {
        self.showError(AppErrors.genericError(message: "The recipient is not a valid username or address.".localized))
    }

    func onInsufficientEthBalanceError() {
        self.showError(AppErrors.genericError(message: "You wallet does not contain enough ETH for the transaction.".localized))
    }

    func onInsufficientTipBalanceError() {
        self.showError(AppErrors.genericError(message: "You wallet does not contain enough TIP for the transaction.".localized))
    }

    func onInvalidTransactionValueError() {
        self.showError(AppErrors.genericError(message: "Invalid transaction value".localized))
    }

    func onWalletError() {
        debugPrint("Error loading wallet:")
    }

    func onSendPendingTransaction(_ tx: PendingTransaction) {
        self.pendingTransaction = tx
        self.performSegue(withIdentifier: "ShowConfirmTransfer", sender: self)
    }

    func onBalanceFetched(_ balance: String, forCurrency currency: Currency) {
        if currency == self.selectedCurrency {
            self.availableFundsField?.text  = balance
        }
        debugPrint("Balance fetched: \(balance)")
    }

    func onBalanceFetchError(_ error: AppErrors) {
        self.showError(error)
    }

    func onContactsFetchError(error: AppErrors) {
        debugPrint("Error fetching contacts: \(error)")
        self.showError(error)
    }

    func onTransactionFeeCalculated(_ txFeeInWei: BigUInt, gasPriceInGwei: Float) {
        self.txFeeInWei = txFeeInWei
        if let feeInEth = EthConvert.toEthereumUnits(txFeeInWei, decimals: 5) {
            self.updateNetworkFeeLabel(feeInEth, gasPrice: gasPriceInGwei)
        }
    }

    func onTransactionFeeError() {
        showError(AppErrors.genericError(message: "Failed to calculated transaction fee. Please try again.".localized))
    }
}

extension SendTransferViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {

    }
}


extension SendTransferViewController: SelectContactDelegate {

    func contactSelected(_ user: User) {
        self.targetAddress = nil
        self.targetUser = user
        self.recepientField?.text = user.username
    }

    func addressEntered(_ address: String) {
        self.targetUser = nil
        self.targetAddress = address
        self.recepientField?.text = address
    }
}
