//
//  InsetTextField.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-08.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {

    @IBInspectable var insets: CGPoint = CGPoint.zero
    var originalContentWidth: CGFloat = 0.0

//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: insets.x, dy: insets.y)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: insets.x, dy: insets.y)
//    }
//
//    override var intrinsicContentSize: CGSize {
//        var contentSize = super.intrinsicContentSize
//        if originalContentWidth == 0.0 {
//            originalContentWidth = contentSize.width
//        }
//        debugPrint("Original IntrinsicContentSize = \(contentSize)")
//        if contentSize.width == 0.0 || contentSize.width.isNaN {
//            contentSize.width = originalContentWidth
//        }
//        debugPrint("Modified IntrinsicContentSize = \(contentSize)")
//        return contentSize
//    }
}
