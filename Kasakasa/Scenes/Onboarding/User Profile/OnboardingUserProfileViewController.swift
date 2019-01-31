//
//  OnboardingUserProfileViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

class OnboardingUserProfileViewController: BaseViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!

    private var profileImage: UIImage?

    private var _checkImageView: UIImageView?
    private var checkImageView: UIImageView {
        if _checkImageView == nil {
            let image = UIImage(named: "icons8-checked")
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            _checkImageView = imageView
        }
        return _checkImageView!
    }

    private var _errorImageView: UIImageView?
    private var errorImageView: UIImageView {
        if _errorImageView == nil {
            let image = UIImage(named: "icons8-error")
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            _errorImageView = imageView
        }
        return _errorImageView!
    }

    private var presenter: OnboardingUserProfilePresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.endEditingOnTap = true
        self.navigationItem.title = "My Profile".localized
        setupPresenter()
        usernameField.rightViewMode = .always
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter?.detach()
        presenter = nil
    }

    private func setupPresenter() {
        presenter = OnboardingUserProfilePresenter()
        presenter?.attach(self)
        presenter?.checkForDemoAccount()
    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        debugPrint("Continue button tapped")
        checkValues()
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
    }

    private func navigateToCreateWallet() {
        self.performSegue(withIdentifier: "GoBackToCreateWallet", sender: self)
    }

    private func navigateToEnterPhoneNubmer() {
        self.performSegue(withIdentifier: "GoBackToEnterPhoneNumber", sender: self)
    }

    private func checkValues() {
        var cancel = false
        var focusView: UIView?

        let firstname = firstnameField.text ?? ""
        let lastname = lastnameField.text ?? ""
        let username = usernameField.text ?? ""

        if firstname.isEmpty {
            showToast("Firstname can not be empty.".localized)
            focusView = firstnameField
            cancel = true
        } else if username.isEmpty {
            showToast("Username can not be empty.".localized)
            focusView = usernameField
            cancel = true
        } else if !username.isUsername() {
            showToast("Username is invalid. Usernames must be between 2 and 16 characters".localized)
            focusView = usernameField
            cancel = true
        }

        if cancel {
            focusView?.becomeFirstResponder()
        } else {
            self.createAccount(firstname: firstname, lastname: lastname, username: username)
        }
    }

    private func createAccount(firstname: String, lastname: String, username: String) {
        self.presenter?.createAccount(firstname: firstname, lastname: lastname, username: username)
    }

    private func showCongratsAlert() {
        self.showAlert(withTitle: "Congrats".localized , message: "You successfully created your TIP account. Welcome to our network".localized, style: UIAlertController.Style.alert) {
            self.navigateToMainApp()
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

extension OnboardingUserProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == self.usernameField, let text = textField.text, let swiftRange = Range(range, in: text) {
            let newString = text.replacingCharacters(in: swiftRange, with: string)
            debugPrint("Checking username: \(newString)")
            self.presenter?.checkUsername(newString)
        }
        return true
    }

}

extension OnboardingUserProfileViewController: OnboardingUserProfileView {

    func onDemoAccountFound(_ user: User) {
        firstnameField.text = user.firstname()
        lastnameField.text = user.lastname()
        usernameField.text = user.username

        usernameField.isEnabled = false
        if let imageUrlString = user.originalPhotoUrl, let imageUrl = URL(string: imageUrlString) {
            let placeholderImage = UIImage.placeHolderImage()
            let loadOptions = ImageLoadingOptions(placeholder: placeholderImage, transition: ImageLoadingOptions.Transition.fadeIn(duration: 0.33), failureImage: placeholderImage, failureImageTransition: .fadeIn(duration: 0.33))
            Nuke.loadImage(with: imageUrl, options: loadOptions, into: profileImageView)
        }
    }

    func onPhotoUploaded() {
        self.showCongratsAlert()
    }

    func onErrorUpdatingUser(_ error: AppErrors) {
        showError(error)
    }

    func onWalletNotSetupError() {
        self.showAlert(withTitle: "Error".localized , message: "You do not have a valid wallet setup. Please create one to proceed".localized, style: UIAlertController.Style.alert) {
            self.navigateToCreateWallet()
        }
    }

    func onSignupTokenError() {
        self.showAlert(withTitle: "Timeout".localized, message: "Your session has timed out. Signup must be completed withing 15 minutes from starting.".localized, style: .alert) {
            self.navigateToEnterPhoneNubmer()
        }
    }

    func onInvalidUser() {
        showError(withTitle: "Error creating account".localized, message: "There was a problem creating your account. Please try again.".localized)
    }

    func onUsernameAvailable() {
        usernameField.rightView = self.checkImageView
    }

    func onUsernameUnavailableError(isDemoAccount: Bool) {
        usernameField.rightView = self.errorImageView
    }

    func onAuthorizationFetched(_ auth: Authorization?, error: AppErrors?) {
        self.view.endEditing(true)
        if let error = error {
            showError(error)
        } else {
            if let profileImage = profileImage {
                presenter?.uploadPhoto(profileImage)
            } else {
                self.showCongratsAlert()
            }
        }
    }

}
