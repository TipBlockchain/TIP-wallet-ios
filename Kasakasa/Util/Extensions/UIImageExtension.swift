//
//  UIImageExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-30.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

extension UIImage {

    static func placeHolderImage() -> UIImage? {
        return UIImage(named: "user_profile_placeholder")
    }

    static func qrCode(fromString string: String, scaleX: CGFloat = 1.0, scaleY: CGFloat = 1.0) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

}
