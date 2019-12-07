//
//  UIViewControllerExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-26.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

extension UIViewController {

    var className: String {
        return String(describing: type(of: self))
    }

    func showToast(_ message: String) {
        self.view.makeToast(message)
    }

    func setNavigationBarTransparent(_ transparent: Bool = true) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }

    func setRegularNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func showPickerController(withTitle title: String, message: String? = nil, style: UIAlertController.Style = .actionSheet, view: UIView? = nil, actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: "Translation Language", message: nil, preferredStyle: .actionSheet)
        if let customView = view {
            alertController.view.addSubview(customView)
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
            customView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -20).isActive = true
            customView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 20).isActive = true
            customView.heightAnchor.constraint(equalToConstant: customView.frame.height).isActive = true

            alertController.view.translatesAutoresizingMaskIntoConstraints = false
            alertController.view.heightAnchor.constraint(equalToConstant: 430).isActive = true
        }


        let selectAction = UIAlertAction(title: "Select", style: .default) { (action) in
            print("selection")
        }

        if let actions = actions {
            for action in actions {
                alertController.addAction(action)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK:- Navigation
    func navigateToMainApp() {
        if let viewController = UIStoryboard(name: "MainApp", bundle: nil).instantiateInitialViewController(),
            let keyWindow = UIApplication.shared.keyWindow {
            switchRootViewController(viewController, inWindow: keyWindow)
        }
    }

    func navigateToOnboarding() {
        if let viewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController(),
            let keyWindow = UIApplication.shared.keyWindow {
            switchRootViewController(viewController, inWindow: keyWindow)
        }
    }

    // MARK:- Alerts
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

    func showOkAlert(withTitle title: String, message: String, style: UIAlertController.Style = .alert, completion: VoidCompletionBlock? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "Okay".localized, style: .cancel) { (action) in
            completion?()
            //            alert.dismiss(animated: true, completion: completion)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showOkCancelAlert(withTitle title: String, message: String, style: UIAlertController.Style = .alert, sourceView: UIView? = nil, onOkSelected okCompletionBlock: VoidCompletionBlock? = nil, onCancelSelected cancelCompletionBlock: VoidCompletionBlock? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "Okay".localized, style: .default) { (action) in
            okCompletionBlock?()
            //            alert.dismiss(animated: true, completion: completion)
        }
        alert.addAction(okAction)

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) in
            cancelCompletionBlock?()
        }
        alert.addAction(cancelAction)
        
        alert.modalPresentationStyle = UIModalPresentationStyle.formSheet
        if let popover = alert.popoverPresentationController, let view = sourceView {
            popover.sourceView = view
            popover.sourceRect = view.bounds
            popover.permittedArrowDirections = [.down, .up]
        }
        self.present(alert, animated: true, completion: nil)
    }

    func showTextFieldAlert(withTitle title: String, message: String, style: UIAlertController.Style = .alert, isSecure: Bool = false, okButtonTitle: String = "Okay", onOkSelected okCompletionBlock: StringCompletionBlock? = nil, onCancelSelected cancelCompletionBlock: VoidCompletionBlock? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.isSecureTextEntry = isSecure
        }

        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: { [weak alert] (_) in
            let text: String? = alert?.textFields?.first?.text
            okCompletionBlock?(text)
        })
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) in
            cancelCompletionBlock?()
        }
        alert.addAction(cancelAction)
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

    private func switchRootViewController(_ rootViewController: UIViewController, inWindow window: UIWindow, animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }

    func startShareActivity(_ text: String) {
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.view
        self.present(activity, animated: true, completion: nil)
    }

    @objc func dismissKeyboard(_ force: Bool = true) {
        self.view.endEditing(force)
    }

    func copyToClipboard(_ text: String) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = text
    }

    func pasteClipboard(into textView: UITextView) {
        textView.text = UIPasteboard.general.string ?? ""
    }

    func pasteClipboard(nito textField: UITextField) {
        textField.text = UIPasteboard.general.string ?? ""
    }

    func openUrl(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        UIApplication.shared.open(url, options: options, completionHandler: completion)
    }

    func openUrl(_ url: URL, fallbackUrl: URL? = nil, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        let sharedApp = UIApplication.shared
        if sharedApp.canOpenURL(url) {
            sharedApp.open(url, options: options, completionHandler: completion)
        } else if let fallbackUrl = fallbackUrl {
            sharedApp.open(fallbackUrl, options: options, completionHandler: completion)
        }
    }

    func showContacts() {
        let contactsPicker = CNContactPickerViewController()
        contactsPicker.delegate = self
        self.present(contactsPicker, animated: true, completion: nil)
    }
    
    func sendSMS(toContacts contacts: [String], withDelegate delegate: MFMessageComposeViewControllerDelegate? = nil) {
        if MFMessageComposeViewController.canSendText() {
            let messagesVC = MFMessageComposeViewController()
            messagesVC.messageComposeDelegate = delegate
            messagesVC.recipients = contacts
            messagesVC.body = "Check out Kasakasa crypto wallet from TIP blockchain. You can send and receive crypto usign usernames https://tipblockchain.io/kasakasa"
            self.present(messagesVC, animated: true, completion: nil)
        } else {
            showToast("Can not send text messages at this time. Please try again later.".localized)
        }
    }
}

extension UIViewController: CNContactPickerDelegate {

    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        debugPrint("Did select contact: \(contact)")
        if let phoneNumber = contact.phoneNumbers.first {
            let phoneNumberString = phoneNumber.value.stringValue
            self.sendSMS(toContacts: [phoneNumberString], withDelegate: nil)
        }
    }

    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        debugPrint("Did select contacts: \(contacts)")
        var phoneNumbers = contacts.map { (contact) -> String in
            if let firstPhoneNumber = contact.phoneNumbers.first {
                let phoneNumberString = firstPhoneNumber.value.stringValue
                return phoneNumberString
            }
            return ""
        }

        phoneNumbers = phoneNumbers.filter({ !$0.isEmpty })
        self.sendSMS(toContacts: phoneNumbers)
    }
}
