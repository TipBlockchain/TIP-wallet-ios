//
//  TipApiService.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-06.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

public class TipApiService: NSObject {

    private let networkService: NetworkService = NetworkService()

    public static var sharedInstance: TipApiService = TipApiService()

    private override init() {

    }

    public func getCountries(completion: @escaping ([Country]?, AppErrors?) -> Void) {
        let request = TipNetworkRequest.getCountries

        networkService.sendRequest(request: request) { (result, error) in
            debugPrint("result = \(String(describing: result)), error = \(String(describing: error))")
            if let resultData = result as? Data, let countries: [Country] = try? JSONDecoder().decode([Country].self, from: resultData) {
                completion(countries, nil)
            } else {
                completion(nil, AppErrors.unknowkError)
            }
        }
    }

    public func getCountry(byCode code: String, completion: @escaping (Country?, AppErrors?) -> Void) {
        let request = TipNetworkRequest.getCountry(code: code)

        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            if let data = result as? Data, let country: Country = try? JSONDecoder().decode(Country.self, from: data) {
                completion(country, nil)
            } else {
                completion(nil, AppErrors.unknowkError)
            }
        }
    }
}
