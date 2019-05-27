//
//  JSONDecoderExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-26.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

extension JSONDecoder {

    public static let defaultDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}
