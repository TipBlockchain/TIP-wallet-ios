//
//  UrlRequestConvertible.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-06.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol UrlRequestConvertible {
    func toUrlRequest() -> URLRequest
}
