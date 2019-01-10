//
//  UIColorExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

extension UIColor {

    func darker(by delta: CGFloat = 0.2) -> UIColor {

        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - delta, 0.0), green: max(g - delta, 0.0), blue: max(b - delta, 0.0), alpha: a)
        }

        return UIColor()
    }

    func lighter(by delta: CGFloat = 0.2) -> UIColor {

        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + delta, 1.0), green: min(g + delta, 1.0), blue: min(b + delta, 1.0), alpha: a)
        }

        return UIColor()
    }
}
