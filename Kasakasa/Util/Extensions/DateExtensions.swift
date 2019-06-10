//
//  DateExtensions.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-09.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

extension Date {

    func dayDiffreence(_ otherDate: Date) -> Int {
        let differenceInComponents = Calendar.current.dateComponents([.day], from: otherDate)
        return differenceInComponents.day ?? 0
    }
}
