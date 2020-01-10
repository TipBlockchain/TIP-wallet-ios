//
//  UIDeviceExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-12-12.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

extension UIDevice {

    var isPhone: Bool {
        return self.userInterfaceIdiom == .phone
    }

    var isIPad: Bool {
        return self.userInterfaceIdiom == .pad
    }
}
