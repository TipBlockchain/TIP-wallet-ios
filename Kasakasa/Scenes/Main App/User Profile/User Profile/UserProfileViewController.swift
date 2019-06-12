//
//  UserProfileViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-09.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

class UserProfileViewController: BaseViewController {

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var fullnameLabel: UILabel!
    @IBOutlet private weak var aboutMeLabel: UILabel!
    @IBOutlet private weak var daysOnTipLabel: UILabel!
    @IBOutlet private weak var submitButton: ColoredButton!
    private var presenter: UserProfilePresenter?
    private var profilePicUrl: URL?

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.addGestureRecognizers()
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter?.detach()
        presenter = nil
    }
    
    @IBAction private func submitButtonTapped(_ sender: Any) {
        if user?.isContact == true {
            self.sendTransfer()
        } else {
            self.addToContacts()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendTransferFromUserProfile", let vc = segue.destination as? SendTransferViewController {
            vc.targetUser = self.user
        } else if segue.identifier == "ShowImageViewFromUserProfile", let vc = segue.destination as? ImageViewController, let profilePicUrl = self.profilePicUrl {
            vc.imageUrl = profilePicUrl
        }
    }

    private func addToContacts() {
        if let user = self.user {
            presenter?.addUserToContacts(user)
        }
    }

    private func sendTransfer() {
        self.performSegue(withIdentifier: "SendTransferFromUserProfile", sender: self)
    }

    func onContactAdded() {
        self.showToast("\(self.user?.username ?? "User") has been added to your contacts.")
        self.user?.isContact = true
        self.updateUI()
    }

    func onContactAddError(_ error: AppErrors) {
        self.showError(error)
    }

    private func updateUI() {
        if let user = user {
            if let photoUrlString = user.originalPhotoUrl, let url = URL(string: photoUrlString) {
                Nuke.loadImage(with: url, into: self.profileImageView)
            }
            usernameLabel.text = user.username
            fullnameLabel.text = user.fullname
            aboutMeLabel.text = user.aboutMe ?? AppConstants.defaultAboutMeText
            if let signupdate = user.created {
                daysOnTipLabel.text = "\(signupdate.dayDiffreence(Date())) days on TIP"
            } else {
                daysOnTipLabel.text = ""
            }
            if user.isContact == true {
                submitButton.setTitle("Send Transfer".localized, for: .normal)
            }
        }
    }

    private func addGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped(_:)))
        self.profileImageView.addGestureRecognizer(tapGesture)
    }

    @objc func profileImageViewTapped(_ sender: Any) {
        if let profilePicUrlString = user?.originalPhotoUrl, let url = URL(string: profilePicUrlString) {
            self.profilePicUrl = url
            self.performSegue(withIdentifier: "ShowImageViewFromUserProfile", sender: self)
        }
    }
}
