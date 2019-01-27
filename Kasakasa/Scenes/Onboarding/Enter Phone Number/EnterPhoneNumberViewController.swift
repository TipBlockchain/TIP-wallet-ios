//
//  EnterPhoneNumberViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class EnterPhoneNumberViewController: BaseViewController {
    typealias View = EnterPhoneNumberView

    private var presenter: EnterPhoneNumberPresenterImpl? = nil
    private var countries: [Country]?
    private var countriesFetched = false
    private var selectedCountry: Country?
    private var countryCode: String? = ""
    private var phoneNumber: String? = ""

    @IBOutlet private var selectCountryTextField: UITextField!
    @IBOutlet private var enterPhoneTextField: UITextField!
    @IBOutlet private var flagImageView: UIImageView!
    @IBOutlet private var countryCodeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Enter your phone number".localized
        self.endEditingOnTap = true
        presenter = EnterPhoneNumberPresenterImpl()
        presenter?.attach(self)
        presenter?.fetchCountryList()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentSelectCountryScreen))
        selectCountryTextField.addGestureRecognizer(gestureRecognizer)
        selectCountryTextField.leftView = flagImageView
        selectCountryTextField.leftViewMode = .always

        selectCountryTextField.delegate = self
        enterPhoneTextField.leftView = countryCodeLabel
        enterPhoneTextField.leftViewMode = .always
    }

    private func getCountries() {
        showActivityIndicator(true)
        presenter?.fetchCountryList()
    }

    fileprivate func enableCountrySelection() {

    }

    @IBAction @objc private func presentSelectCountryScreen(_ sender: Any) {
        guard countriesFetched else {
            return
        }
        self.performSegue(withIdentifier: "OpenSelectCountryViewController", sender: self)
    }
    
    @IBAction func checkPhoneNumber(_ sender: Any) {
        if let countryCode = selectedCountry?.countryCode,
            let phoneNumber = enterPhoneTextField.text {
            self.phoneNumber = phoneNumber
            self.countryCode = String(countryCode)
            let verificationRequest = PhoneVerificationRequest(countryCode: String(countryCode), phoneNumber: phoneNumber, verificationCode: nil)
            showActivityIndicator()
            presenter?.validatePhoneNumber(verificationRequest)
        } else {
            self.onInvalidPhoneNumberError()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenSelectCountryViewController",
            let destinationNavController = segue.destination as? UINavigationController,
            let destinationViewController = destinationNavController.topViewController as? SelectCountryViewController,
            let countries = countries {
            destinationViewController.countries = countries
            destinationViewController.delegate = self
        }
        if segue.identifier == "ShowVerifyPhoneNumber", let destinationViewController = segue.destination as? VerifyPhoneNumberViewController {
            destinationViewController.phoneNumber = phoneNumber
            destinationViewController.countryCode = countryCode
        }
    }

    private func navigateToVerifyPhoneNumber() {
        self.performSegue(withIdentifier: "ShowVerifyPhoneNumber", sender: self)
    }

    deinit {
        presenter?.detach()
    }

}

// Mark: EnterPhoneNumberView
extension EnterPhoneNumberViewController: EnterPhoneNumberView {
    func onVerificationError(err: AppErrors) {
        showActivityIndicator(false)
        showError(err)
    }


    func onEmptyPhoneNumberError() {
        showActivityIndicator(false)
        let error = AppErrors.genericError(message: "Phone number can not be empty. Please enter a valid phone number".localized)
        showError(error)
    }

    func onInvalidPhoneNumberError() {
        showActivityIndicator(false)
        let error = AppErrors.genericError(message: "The phone number entered is invalid. Please enter a valid phone number".localized)
        showError(error)
    }

    func onVerificationStartedSuccessfully() {
        showActivityIndicator(false)
        self.navigateToVerifyPhoneNumber()
    }

    func onCountryListFetched(_ countries: [Country]) {
        countriesFetched = true
        enterPhoneTextField.isEnabled = true
        selectCountryTextField.placeholder = "Select your country".localized
        showActivityIndicator(false)
        self.countries = countries
        enableCountrySelection()
    }

    func onCountryListError(err: AppErrors) {
        showActivityIndicator(false)
        showError(err)
    }

}

// Mark: TextField Delegate

extension EnterPhoneNumberViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return textField != self.selectCountryTextField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension EnterPhoneNumberViewController: SelectCountryDelegate {
    func countrySelected(_ country: Country) {
        selectedCountry = country

        flagImageView.isHidden = false
        flagImageView.image = country.flagImage
        selectCountryTextField.text = country.niceName

        countryCodeLabel.isHidden = false
        countryCodeLabel.text = "+\(country.countryCode)"
        countryCodeLabel.sizeToFit()
        enterPhoneTextField.placeholder = ""
    }
}
