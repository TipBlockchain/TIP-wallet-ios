//
//  SplashScreen.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol SplashScreenView: class, BaseView {
    func goToOnboarding()
    func goToMainApp()
}
