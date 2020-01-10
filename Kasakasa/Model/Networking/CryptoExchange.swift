//
//  CryptoExchange.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit


public struct CryptoExchange: Codable {
    var name: String
    var displayName: String
    var url: String
    var logoUrl: String?
    var logoName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case displayName = "displayName"
        case url
        case logoUrl = "logoUrl"
        case logoName = "logoName"
    }

    var logoImage: UIImage? {
        if let logoName = self.logoName {
            return UIImage(named: logoName)
        }
        
        return nil
    }
}
