//
//  BytesFactoryTests.swift
//  CryCipherTests
//
//  Created by Thibault Defeyter on 19/10/2019.
//

import XCTest
@testable import CryCipher

class BytesFactoryTests: XCTestCase {
    static var allTests = [
        ("testBytesFromBytes_simple", testBytesFromBytes_simple),
        ("testBytesFromBytes_offset", testBytesFromBytes_offset),
        ("testBytesFromBytes_count", testBytesFromBytes_count),
        ("testBytesFromBytes_offsetAndCount", testBytesFromBytes_offsetAndCount),
        ("testBytesFromData", testBytesFromData),
        ("testBytesFromString", testBytesFromString)
    ]

    func testBytesFromBytes_simple() {
        let factory = BytesFactoryImpl()
        XCTAssertEqual(
            factory.bytes(fromBytes: [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33]),
            [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33]
        )
    }

    func testBytesFromBytes_offset() {
        let factory = BytesFactoryImpl()
        XCTAssertEqual(
            factory.bytes(fromBytes: [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33], offset: 6),
            [119, 111, 114, 108, 100, 33]
        )
    }

    func testBytesFromBytes_count() {
        let factory = BytesFactoryImpl()
        XCTAssertEqual(
            factory.bytes(fromBytes: [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33], count: 5),
            [104, 101, 108, 108, 111]
        )
    }

    func testBytesFromBytes_offsetAndCount() {
        let factory = BytesFactoryImpl()
        XCTAssertEqual(
            factory.bytes(
                fromBytes: [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33],
                offset: 6,
                count: 5
            ),
            [119, 111, 114, 108, 100]
        )
    }

    func testBytesFromData() {
        let factory = BytesFactoryImpl()
        XCTAssertEqual(
            factory.bytes(fromData: "hello world!".data(using: .utf8)!),
            [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33]
        )
    }

    func testBytesFromString() {
        let factory = BytesFactoryImpl()
        XCTAssertEqual(
            factory.bytes(fromString: "hello world!"),
            [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33]
        )
    }
}
