//
//  TutorialViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

protocol TutorialDelegate: class {
    func tutorialComplete()
}

class TutorialViewController: UIViewController {

    weak var delegate: TutorialDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func createAccountButtonTapped(_ sender: Any) {
        self.delegate?.tutorialComplete()
    }

}
