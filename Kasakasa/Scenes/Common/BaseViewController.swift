//
//  BaseViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-08.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Toast_Swift

typealias VoidCompletionBlock = (() -> Void)

class BaseViewController: UIViewController {

    private var activityIndicator: UIActivityIndicatorView?

    private var _tapGestureRecognizer: UITapGestureRecognizer?
    private var endEditingGestureRecognizer: UITapGestureRecognizer {
        if _tapGestureRecognizer == nil {
            _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        }
        return _tapGestureRecognizer!
    }

    var endEditingOnTap: Bool = false {
        didSet {
            if endEditingOnTap {
                self.view.addGestureRecognizer(endEditingGestureRecognizer)
            } else {
                self.view.removeGestureRecognizer(endEditingGestureRecognizer)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

   func navigateToMainApp() {
        let mainAppRootVC = UIStoryboard(name: "MainApp", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = mainAppRootVC
    }

    func showError(_ error: AppErrors, completion: VoidCompletionBlock? = nil) {
        self.showError(withTitle: "Sorry".localized, message: error.message, completion: completion)
    }


    func showError(withTitle title: String, message: String, style: UIAlertController.Style = .alert, completion: VoidCompletionBlock? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "Okay".localized, style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: completion)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showAlert(withTitle title: String, message: String, style: UIAlertController.Style = .alert, completion: VoidCompletionBlock? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "Okay".localized, style: .cancel) { (action) in
            completion?()
//            alert.dismiss(animated: true, completion: completion)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func dismissKeyboard(_ force: Bool = true) {
        self.view.endEditing(force)
    }

    func showActivityIndicator(_ show: Bool = true) {
        if show, activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.center = self.view.center
            self.view.addSubview(activityIndicator!)
        }

        if show, let activityIndicator = activityIndicator {
            self.view.bringSubviewToFront(activityIndicator)
            activityIndicator.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }

    func showToast(_ message: String) {
        self.view.makeToast(message)
    }
}
