//
//  EditAboutMeViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class EditAboutMeViewController: BaseViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    private let maxCount = 120
    private var presenter: EditAboutMePresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.endEditingOnTap = true

        presenter = EditAboutMePresenter()
        presenter?.attach(self)
        textView.text = UserRepository.shared.currentUser?.aboutMe ?? ""
        self.updateCountLabel(textView.text)
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter?.detach()
    }
    @IBAction func updatePressed(_ sender: Any) {
        let aboutMeText = textView.text ?? ""
        if aboutMeText.isEmpty {
            self.showError(AppErrors.genericError(message: "About me text should not be empty.".localized))
            return
        }
        presenter?.updateAboutMe(aboutMeText)
    }

    private func updateCountLabel(_ text: String) {
        let count = text.count
        countLabel.text = "\(count)/\(maxCount)"
    }

    func onAboutMeUpdated() {
        self.showToast("About me updated.".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func onAboutMeError(_ error: AppErrors) {
        self.showError(error)
    }

}

extension EditAboutMeViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        self.updateCountLabel(text)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }

        if range.length == 0, text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        return count <= maxCount
    }
}
