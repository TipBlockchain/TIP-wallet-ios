//
//  DictionaryEncodable.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol DictionaryEncodable: Encodable {}

extension DictionaryEncodable {
    func dictionary() -> Json? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
                return nil
        }
        return dict
    }
}
