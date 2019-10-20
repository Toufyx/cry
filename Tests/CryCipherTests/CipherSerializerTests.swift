//
//  CipherSerializerTests.swift
//  CryCipherTests
//
//  Created by Thibault Defeyter on 20/10/2019.
//

import XCTest
import Foundation
@testable import CryCipher

// swiftlint:disable force_try
class CipherSerializerTests: XCTestCase {
    static var allTests = [
        ("testSerialize", testSerialize),
        ("testDeserialize", testDeserialize)
    ]

    static let validSaltBytes = [UInt8](0...31)
    static let validInitVectorBytes = [UInt8](0...15)
    static let validEncryptedDataBytes = [UInt8](128...255)

    let serializer = CipherSerializer()
    let validCipher = Cipher(
        salt: CipherSerializerTests.validSaltBytes,
        initializationVector: CipherSerializerTests.validInitVectorBytes,
        encryptedContent: CipherSerializerTests.validEncryptedDataBytes
    )
    let validData = ([67, 82, 89, 48, 48, 48, 48, 49]
        + CipherSerializerTests.validSaltBytes
        + CipherSerializerTests.validInitVectorBytes
        + CipherSerializerTests.validEncryptedDataBytes
    )

    func testSerialize() {
        XCTAssertEqual(try! self.serializer.serialize(item: self.validCipher), self.validData)
    }

    func testDeserialize() {
        XCTAssertEqual(try! serializer.deserialize(bytes: self.validData), self.validCipher)
    }
}
