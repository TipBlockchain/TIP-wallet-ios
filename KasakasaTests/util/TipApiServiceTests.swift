//
//  TipApiServiceTests.swift
//  KasakasaTests
//
//  Created by John Warmann on 2019-01-06.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import XCTest
import Kasakasa

class TipApiServiceTests: XCTestCase {


    var apiService: TipApiService!
    
    override func setUp() {
        apiService = TipApiService.sharedInstance
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCountries() {
        let exp = expectation(description: "get countries")
        apiService.getCountries { (json, error) in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1000)
    }

}
