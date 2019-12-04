//
//  OnboardingUserProfileViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

class OnboardingUserProfileViewController: BaseTableViewController {

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileImageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var cameraButton: UIButton!

    @IBOutlet private weak var firstnameField: UITextField!
    @IBOutlet private weak var lastnameField: UITextField!
    @IBOutlet private weak var usernameField: UITextField!

    @IBOutlet private weak var signupButton: UIBarButtonItem!

    private var profileImage: UIImage?
    private var imagePicker: ImagePicker!
    private var hasPromptedToUploadImage = false
    private var isUsernameAvailable = false

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

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        self.signupButton.isEnabled = true
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
        self.view.endEditing(true)
        self.signupButton.isEnabled = false
        checkValues()
    }

    @IBAction func cameraButtonTapped(_ sender: UIView) {
        self.imagePicker.present(from: sender)
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
        } else if !self.isUsernameAvailable {
            self.showToast("Chosen username is not available")
            focusView = usernameField
            cancel = true
        }  else if profileImage == nil && !hasPromptedToUploadImage {
            self.promptToUploadPhoto()
            cancel = true
        }

        if cancel {
            focusView?.becomeFirstResponder()
        } else {
            self.createAccount(firstname: firstname, lastname: lastname, username: username)
        }
    }

    private func promptToUploadPhoto() {
        self.hasPromptedToUploadImage = true

        let alert = UIAlertController(title: "Upload Photo".localized, message: "You should personalize your account with a photo so your contacts know its you.".localized, preferredStyle: .actionSheet)
        let choosePhotoAction = UIAlertAction(title: "Choose Photo".localized, style: .default) { (action) in
            self.cameraButtonTapped(self.cameraButton)
        }
        let continueAction = UIAlertAction(title: "Continue without photo".localized, style: .default) { (action) in
            self.checkValues()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in

        }
        alert.addAction(choosePhotoAction)
        alert.addAction(continueAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    private func createAccount(firstname: String, lastname: String, username: String) {
        self.showActivityIndicator()
        self.presenter?.createAccount(firstname: firstname, lastname: lastname, username: username)
    }

    private func showCongratsAlert() {
        self.showActivityIndicator(false)
        self.showOkAlert(withTitle: "Congrats".localized , message: "You successfully created your TIP account. Welcome to our network".localized, style: UIAlertController.Style.alert) {
            self.navigateToMainApp()
        }
    }

    private func configureCropper(forImage image: UIImage) {
        var config = ImageCropperConfiguration(with: image, and: .square)
        config.maskFillColor = UIColor.black.withAlphaComponent(0.5)
        config.borderColor = UIColor.black

        config.showGrid = true
        config.gridColor = UIColor.white
        config.doneTitle = "Crop"
        config.cancelTitle = "Cancel"

        let imageCropper = ImageCropperViewController.initialize(with: config) { croppedImage in
            if let croppedImage = croppedImage {
                //                self.profileImageView.image = croppedImage
//                self.profileImageActivityIndicator.startAnimating()
                self.profileImage = croppedImage
                self.profileImageView.image = croppedImage
//                self.presenter?.uploadPhoto(croppedImage)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showError(withTitle: "Profile photo error".localized, message: "There was a problem cropping your photo. Please try again with a different picture.".localized)
            }
        }
        self.present(imageCropper, animated: false, completion: nil)
    }
}

extension OnboardingUserProfileViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        if let image = image {
            self.configureCropper(forImage: image)
        }
    }
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

    func onPhotoUploadError(_ error: AppErrors) {
        self.showActivityIndicator(false)
        showError(error)
    }

    func onErrorUpdatingUser(_ error: AppErrors) {
        showError(error)
    }

    func onWalletNotSetupError() {
        self.showOkAlert(withTitle: "Error".localized , message: "You do not have a valid wallet setup. Please create one to proceed".localized, style: UIAlertController.Style.alert) {
            self.navigateToCreateWallet()
        }
    }

    func onSignupTokenError() {
        self.showOkAlert(withTitle: "Timeout".localized, message: "Your session has timed out. Signup must be completed withing 15 minutes from starting.".localized, style: .alert) {
            self.navigateToEnterPhoneNubmer()
        }
    }

    func onInvalidUser() {
        showError(withTitle: "Error creating account".localized, message: "There was a problem creating your account. Please try again.".localized)
    }

    func onUsernameAvailable() {
        self.isUsernameAvailable = true
        usernameField.rightView = self.checkImageView
    }

    func onUsernameUnavailableError(isDemoAccount: Bool) {
        self.showActivityIndicator(false)
        self.isUsernameAvailable = false
        usernameField.rightView = self.errorImageView
    }

    func onAuthorizationFetched(_ auth: Authorization?, error: AppErrors?) {
        AppAnalytics.logEvent(.signedUp)

        self.view.endEditing(true)
        if let error = error {
            self.showActivityIndicator(false)
            showError(error)
        } else {
            if let profileImage = profileImage {
                self.presenter?.uploadPhoto(profileImage)
            } else {
                self.showCongratsAlert()
            }
        }
    }
}
