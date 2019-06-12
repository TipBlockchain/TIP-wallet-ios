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
        navigationBarAppearance.barTintColor = UIColor.appPink

        let searchBarAppearance = UISearchBar.appearance()
        searchBarAppearance.tintColor = UIColor.appPink
//        searchBarAppearance.backgroundColor = UIColor.appPurple
        searchBarAppearance.barTintColor = UIColor.appPink

        let textFieldInSearchBarAppearance = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self, UIToolbar.self])
        textFieldInSearchBarAppearance.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        UIBarButtonItem.appearance(whenContainedInInstancesOf:
            [UISearchBar.self]).setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBar.appearance().tintColor = UIColor.appPink
    }
}
