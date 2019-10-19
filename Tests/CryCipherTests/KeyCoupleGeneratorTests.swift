//
//  KeyCoupleGeneratorTests.swift
//  CryCipherTests
//
//  Created by Thibault Defeyter on 19/10/2019.
//

import XCTest
@testable import CryCipher

// swiftlint:disable force_try
class KeyCoupleGeneratorTests: XCTestCase {
    static var allTests = [
        ("testGenerate_length", testGenerate_length),
        ("testGenerate_difference", testGenerate_difference),
        ("testGenerate_consistency", testGenerate_consistency)
    ]

    func testGenerate_length() {
        let generator = KeyCoupleGeneratorImpl()
        let key = try! generator.generateKeyCouple(fromPassword: [1, 2, 3, 4, 5], andSalt: [54, 109, 122, 1, 34])
        XCTAssertEqual(key.encryptionKey.count, 32)
        XCTAssertEqual(key.hashKey.count, 32)
    }

    func testGenerate_difference() {
        let generator = KeyCoupleGeneratorImpl()
        let key = try! generator.generateKeyCouple(fromPassword: [10, 9, 36, 74, 105], andSalt: [24, 119, 22, 19, 45])
        XCTAssertNotEqual(key.encryptionKey, key.hashKey)
    }

    func testGenerate_consistency() {
        let generator = KeyCoupleGeneratorImpl()
        let key1 = try! generator.generateKeyCouple(fromPassword: [1, 2, 3, 4, 5], andSalt: [6, 7, 8, 9, 10])
        let key2 = try! generator.generateKeyCouple(fromPassword: [1, 2, 3, 4, 5], andSalt: [6, 7, 8, 9, 10])
        XCTAssertEqual(key1.encryptionKey, key2.encryptionKey)
        XCTAssertEqual(key1.hashKey, key2.hashKey)
    }
}
