//
//  Country.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-06.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

public struct Country: Codable {
    var isRestricted: Bool
    var isBlocked: Bool
    var name: String
    var niceName: String
    var numericCode: Int?
    var iso: String
    var iso3: String?
    var countryCode: Int

    var nameWithCountryCode: String {
        return "\(niceName) (+\(countryCode))"
    }

    var flagImage: UIImage {
        if let flagImage = UIImage(named: iso) {
            return flagImage
        } else {
            return UIImage(named: "dark_gray_solid")!
        }
    }
}
