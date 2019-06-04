//
//  AppStyle.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class AppStyle {
    
    static func initialize() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        UITabBar.appearance().tintColor = UIColor.appPink
    }
}
