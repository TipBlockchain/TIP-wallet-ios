//
//  UIViewControllerExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-26.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

extension UIViewController {


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
}
