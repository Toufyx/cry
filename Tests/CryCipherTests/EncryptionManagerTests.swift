//
//  EncryptionManagerTests.swift
//  CryCipherTests
//
//  Created by Thibault Defeyter on 20/10/2019.
//

import XCTest
@testable import CryCipher

// swiftlint:disable force_try
class EncryptionManagerTests: XCTestCase {
    static var allTests = [
        ("testEncrypt", testEncrypt),
        ("testDecrypt", testDecrypt),
        ("testNilpotency", testNilpotency)
    ]

    func testEncrypt() {
        let manager = EncryptionManager()
        let message = [UInt8]("hello world!".utf8)
        let secret = EncryptionSecret(key: [UInt8](1...32), initializationVector: [UInt8](1...16))
        let encryptedMessage = [UInt8]([137, 232, 241, 11, 249, 110, 224, 98, 126, 77, 204, 25, 34, 67, 118, 181])
        XCTAssertEqual(try! manager.encrypt(content: message, withSecret: secret), encryptedMessage)
    }

    func testDecrypt() {
        let manager = EncryptionManager()
        let message = [UInt8]("hello world!".utf8)
        let secret = EncryptionSecret(key: [UInt8](1...32), initializationVector: [UInt8](1...16))
        let encryptedMessage = [UInt8]([137, 232, 241, 11, 249, 110, 224, 98, 126, 77, 204, 25, 34, 67, 118, 181])
        XCTAssertEqual(try! manager.decrypt(content: encryptedMessage, withSecret: secret), message)
    }

    func testNilpotency() {
        let manager = EncryptionManager()
        let message = [UInt8]("secret message".utf8)
        let secret = EncryptionSecret(key: [UInt8](33...64), initializationVector: [UInt8](1...16))
        let encryptedMessage = try! manager.encrypt(content: message, withSecret: secret)
        XCTAssertEqual(try! manager.decrypt(content: encryptedMessage, withSecret: secret), message)
    }
}
