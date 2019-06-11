//
//  Currency.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-21.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public enum Currency: String, Codable {
    case TIP
    case ETH

    var name: String {
        switch self {
        case .ETH:
            return "Ethereum"
        case .TIP:
            return "Tip"
        }
    }

    var symbol: String {
        return self.rawValue.uppercased()
    }
}
