//
//  EncryptionManager.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 19/10/2019.
//

import Foundation
import CryptoSwift


/// Data container for Encryption Secret
struct EncryptionSecret {
    let key: [UInt8]
    let initializationVector: [UInt8]
}


/// Manage the AES Encryption
struct EncryptionManager: Manager {
    typealias ClearContent = [UInt8]
    typealias EncryptedContent = [UInt8]
    typealias Secret = EncryptionSecret

    /// Encrypt a message with a Key and a IV
    func encrypt(content: ClearContent, withSecret secret: Secret) throws -> EncryptedContent {
        return try AES(
            key: secret.key,
            blockMode: CBC(iv: secret.initializationVector),
            padding: .pkcs7
        ).encrypt(content)
    }

    /// Decrypt a cypher with a Key and a IV
    func decrypt(content: EncryptedContent, withSecret secret: Secret) throws -> ClearContent {
        return try AES(
            key: secret.key,
            blockMode: CBC(iv: secret.initializationVector),
            padding: .pkcs7
        ).decrypt(content)
    }
}
