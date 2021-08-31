//
//  RightViewTextField.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-12-22.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class RightViewTextField: UITextField {

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let width: CGFloat = 30
        let height: CGFloat = 30
        let rectBounds = CGRect(x: self.bounds.width - width, y: self.bounds.center.y - height/2, width: width, height: height)
        return rectBounds
    }
}
