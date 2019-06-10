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

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter?.detach()
        presenter = nil
    }
    
    @IBAction private func submitButtonTapped(_ sender: Any) {
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
        }
    }
}
