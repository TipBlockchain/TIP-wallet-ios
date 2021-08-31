//
//  TextUtilTests.swift
//  KasakasaTests
//
//  Created by John Warmann on 2019-05-31.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import XCTest
import Kasakasa

class TextUtilTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEthAddresses() {
        let a1 = "0x8c27821Fe2254b68F8c6006B8bCE077d2c091BFa"
        let fake = "0x20052808520820282852858285285r2885222"
        XCTAssertTrue(TextUtils.isEthAddress(a1))
        XCTAssertTrue(TextUtils.isEthAddress(a1.uppercased()))
        XCTAssertTrue(TextUtils.isEthAddress(a1.lowercased()))

        XCTAssertFalse(TextUtils.isEthAddress(fake))

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
