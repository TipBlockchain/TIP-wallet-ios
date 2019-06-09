//
//  EditFullnameViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class EditFullnameViewController: BaseViewController {

    @IBOutlet weak var textField: UITextField!
    private var user: User?
    private var presenter: EditFullnamePresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = EditFullnamePresenter()
        presenter?.attach(self)

        self.endEditingOnTap = true
        self.user = UserRepository.shared.currentUser
        textField.text = user?.fullname ?? ""
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter?.detach()
    }
    

    @IBAction func updatePressed(_ sender: Any) {
        self.showActivityIndicator()
        let fullname = textField.text

        guard fullname !=  nil else {
            showError(AppErrors.genericError(message: "Fullname can not be empty".localized))
            return
        }

        guard !fullname!.isEmpty && fullname!.count >= 3 else {
            showError(AppErrors.genericError(message: "Full name must be at least three characters long.".localized))
            return
        }
        presenter?.updateFullname(fullname!)
    }

    func onFullnameUpdated() {
        self.showActivityIndicator(false)
        self.showToast("Full name updated".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func onFullnameUpdateError(_ error: AppErrors) {
        self.showActivityIndicator(false)
        self.showError(error)
    }

}

extension EditFullnameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
