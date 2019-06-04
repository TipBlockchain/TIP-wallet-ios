//
//  UIColorExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }

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

    static let inGreen = UIColor(rgb: 0x00C853)
    static let outRed = UIColor(rgb: 0xFF1744)
    static let appPink = UIColor(rgb: 0xB62B8D)
    static let appPinkLight = UIColor(rgb: 0xD46AB0)
    static let appPurple = UIColor(rgb: 0x341E7D)
    static let appPurpleDark = UIColor(rgb: 0x26144B)
}
