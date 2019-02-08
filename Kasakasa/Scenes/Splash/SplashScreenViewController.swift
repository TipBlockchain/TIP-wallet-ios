//
//  SplashScreenViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseViewController {

    var presenter: SplashScreenPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = SplashScreenPresenter()
        presenter?.attach(self)
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
//            self.presenter?.checkForUserAndWallet()
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter?.checkForUserAndWallet()
    }
    
}

extension SplashScreenViewController: SplashScreenView {
    
    func goToOnboarding() {
        self.navigateToOnboarding()
    }

    func goToMainApp() {
        self.navigateToMainApp()
    }
}


