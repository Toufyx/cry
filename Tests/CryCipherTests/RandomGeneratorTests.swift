//
//  SimpleCryptoTests.swift
//  CryCipherTests
//
//  Created by Thibault Defeyter on 19/10/2019.
//

import XCTest
@testable import CryCipher

class RandomManagerTests: XCTestCase {
    static var allTests = [
        ("testRandomBytesLength", testRandomBytesLength),
        ("testRandomBytesRandomness", testRandomBytesRandomness),
    ]

    func testRandomBytesLength() {
        let generator = RandomGeneratorImpl()
        let bytes = try! generator.generateRandomBytes(length:8)
        XCTAssertEqual(bytes.count, 8)
    }

    func testRandomBytesRandomness() {
        let generator = RandomGeneratorImpl()
        let bytes1 = try! generator.generateRandomBytes(length:8)
        let bytes2 = try! generator.generateRandomBytes(length:8)
        XCTAssertNotEqual(bytes1, bytes2)
    }
}
