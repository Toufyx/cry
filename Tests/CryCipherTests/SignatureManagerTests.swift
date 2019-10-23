//
//  SignatureManagerTests.swift
//  CryCipherTests
//
//  Created by Thibault Defeyter on 23/10/2019.
//

import XCTest
@testable import CryCipher

// swiftlint:disable force_try
class SignatureManagerTests: XCTestCase {
    static var allTests = [
        ("testSign", testSign),
        ("testVerify_Success", testVerify_Success),
        ("testVerify_Failure", testVerify_Failure)
    ]

    static let validKeyBytes = [UInt8](1...32)
    static let invalidKeyBytes = [UInt8](33...64)
    static let validEncryptedDataBytes = [UInt8](128...255)
    static let validSignatureBytes = [UInt8]([236, 190, 107, 117, 114, 16, 63, 142]
        + [44, 142, 63, 170, 196, 215, 222, 173]
        + [188, 114, 41, 8, 203, 19, 4, 63]
        + [48, 101, 169, 120, 17, 199, 112, 58]
    )

    func testSign() {
        let manager = HashSignatureManager()
        let signature = try! manager.sign(
            content: HashContent(
                key: SignatureManagerTests.validKeyBytes,
                encryptedBytes: SignatureManagerTests.validEncryptedDataBytes
            )
        )
        XCTAssertEqual(signature, SignatureManagerTests.validSignatureBytes)
    }

    func testVerify_Success() {
        let manager = HashSignatureManager()
        XCTAssertNoThrow(
            try manager.verify(
                content: HashContent(
                    key: SignatureManagerTests.validKeyBytes,
                    encryptedBytes: SignatureManagerTests.validEncryptedDataBytes
                ),
                signature: SignatureManagerTests.validSignatureBytes
            )
        )
    }

    func testVerify_Failure() {
        let manager = HashSignatureManager()
        XCTAssertThrowsError(
            try manager.verify(
                content: HashContent(
                    key: SignatureManagerTests.invalidKeyBytes,
                    encryptedBytes: SignatureManagerTests.validEncryptedDataBytes
                ),
                signature: SignatureManagerTests.validSignatureBytes
            )
        )
    }
}
