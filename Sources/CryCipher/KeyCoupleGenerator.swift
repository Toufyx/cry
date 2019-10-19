//
//  KeyCoupleGenerator.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 19/10/2019.
//

import Foundation
import CryptoSwift


/// Data structure containing Encryption and Hash Keys used to encrypt and hash the content.
struct KeyCouple {

    /// The expected key's length
    static let hashKeyLength = 32
    static let encryptionKeyLength = 32

    /// The key used for Encryption and Hash Algorithms
    let hashKey: [UInt8]
    let encryptionKey: [UInt8]
}


/// Class interface
protocol KeyCoupleGenerator {
    func generateKeyCouple(fromPassword password: [UInt8], andSalt salt: [UInt8]) throws -> KeyCouple
}

/// Manager generating AES and HMAC Keys
struct KeyCoupleGeneratorImpl: KeyCoupleGenerator {

    /// Generate a AES and HMAC Keys couple from password and salt
    func generateKeyCouple(fromPassword password: [UInt8], andSalt salt: [UInt8]) throws -> KeyCouple {
        let key = try PKCS5.PBKDF2(
            password: password,
            salt: salt,
            iterations: 4096,
            keyLength: KeyCouple.hashKeyLength + KeyCouple.encryptionKeyLength,
            variant: .sha256
        ).calculate()
        return KeyCouple(
            hashKey: Array(key.prefix(KeyCouple.hashKeyLength)),
            encryptionKey: Array(key.suffix(KeyCouple.encryptionKeyLength))
        )
    }
}
