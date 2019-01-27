//
//  OnboardingUserProfileViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class OnboardingUserProfileViewController: BaseViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.endEditingOnTap = true
        self.navigationItem.title = "My Profile".localized
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        debugPrint("Continue button tapped")
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
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
}
