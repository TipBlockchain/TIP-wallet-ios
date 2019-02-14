//
//  ModalViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-08.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class ModalViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ModalViewController.close))
        self.navigationItem.leftBarButtonItem = closeButton

        // Do any additional setup after loading the view.
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
