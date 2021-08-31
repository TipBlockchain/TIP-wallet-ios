//
//  ExistingAccountViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

class ExistingAccountViewController: BaseTableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    var demoAccountUser: User?
    var existingUser: User?
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Welcome to TIP Kasakasa".localized
        if demoAccountUser == nil && existingUser == nil {
            self.showError(withTitle: "Error".localized, message: "We could not retrieve your account. Please try again") {
                self.navigationController?.popToRootViewController(animated: true)
            }
            return
        }

        self.currentUser = self.demoAccountUser ?? self.existingUser
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func restoreWalletTapped(_ sender: Any) {
        self.navigateToNextScreen()
    }

    private func updateUI() {
        guard currentUser != nil else {
            return
        }

        usernameLabel.text =  self.currentUser?.username
        if  let imageUrlString = currentUser?.originalPhotoUrl, let imageUrl = URL(string: imageUrlString)  {
            let placeholderImage = UIImage.placeHolderImage()
            let loadOptions = ImageLoadingOptions(placeholder: placeholderImage, transition: ImageLoadingOptions.Transition.fadeIn(duration: 0.33), failureImage: placeholderImage, failureImageTransition: .fadeIn(duration: 0.33))
            Nuke.loadImage(with: imageUrl, options: loadOptions, into: profileImageView)
        }

        if self.currentUser == self.existingUser {
//            messageLabel.text = "You will have to restore your wallet using the recovery phrase you used to create it.".localized
        }
    }

    private func navigateToNextScreen() {
        if self.currentUser == self.existingUser {
            self.performSegue(withIdentifier: "ShowRestoreWallet", sender: self)
        } else {
            self.performSegue(withIdentifier: "ShowRecoveryPhraseFromDemoAccount", sender: self)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRestoreWallet",
            let vc = segue.destination as? RestoreWalletViewController {
            vc.existingUser = self.existingUser
        }
    }

}
