//
//  JSONDecoderExtension.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-26.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

extension JSONDecoder {

    public static let epochDateDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    public static let isoDateDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
