//
//  CipherManagerTests.swift
//  CryCipherTests
//
//  Created by Thibault Defeyter on 19/10/2019.
//

import XCTest
@testable import CryCipher

// swiftlint:disable force_try
class CipherManagerTests: XCTestCase {
    static var allTests = [
        ("testDecrypt", testDecrypt),
        ("testEncrypt", testEncrypt),
        ("testNilpotency", testNilpotency)
    ]

    static let validSaltBytes = [UInt8](1...32)
    static let validKeyBytes = [UInt8](1...32)
    static let validInitVectorBytes = [UInt8](1...16)
    static let validEncryptedDataBytes = [UInt8](128...255)
    static let validDecryptedDataBytes = [UInt8]("Hello World!".utf8)
    static let validSecretBytes = [UInt8]("password".utf8)

    static let validCipher = Cipher(
        salt: CipherManagerTests.validSaltBytes,
        initializationVector: CipherManagerTests.validInitVectorBytes,
        encryptedBytes: CipherManagerTests.validEncryptedDataBytes
    )

    func testDecrypt() {
        let manager = CipherManager(
            encryptionManager: AnyManager(
                manager: EncryptionManagerStub(decryptedContent: CipherManagerTests.validDecryptedDataBytes)
            ),
            randomGenerator: RandomGeneratorStub(),
            keyCoupleGenerator: KeyCoupleGeneratorStub()
        )
        XCTAssertEqual(
            try! manager.decrypt(
                content: CipherManagerTests.validCipher,
                withSecret: CipherManagerTests.validSecretBytes
            ),
            CipherManagerTests.validDecryptedDataBytes
        )
    }

    func testEncrypt() {
        let manager = CipherManager(
            encryptionManager: AnyManager(
                manager: EncryptionManagerStub(encryptedBytes: CipherManagerTests.validEncryptedDataBytes)
            ),
            randomGenerator: RandomGeneratorStub(randomBytesClosure: { return [UInt8](1...$0)}),
            keyCoupleGenerator: KeyCoupleGeneratorStub(encryptionKey: CipherManagerTests.validKeyBytes)
        )
        XCTAssertEqual(
            try! manager.encrypt(
                content: CipherManagerTests.validDecryptedDataBytes,
                withSecret: CipherManagerTests.validSecretBytes
            ),
            Cipher(
                salt: CipherManagerTests.validSaltBytes,
                initializationVector: CipherManagerTests.validInitVectorBytes,
                encryptedBytes: CipherManagerTests.validEncryptedDataBytes
            )
        )
    }

    func testNilpotency() {
        let manager = CipherManager()
        let cipher = try! manager.encrypt(
            content: CipherManagerTests.validDecryptedDataBytes,
            withSecret: CipherManagerTests.validSecretBytes
        )
        XCTAssertEqual(
            try! manager.decrypt(content: cipher, withSecret: CipherManagerTests.validSecretBytes),
            CipherManagerTests.validDecryptedDataBytes
        )
    }
}
