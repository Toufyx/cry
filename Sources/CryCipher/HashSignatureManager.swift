//
//  HashSignatureManager.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 23/10/2019.
//

import CryptoSwift


/// The bytes to be signed and the key used to sign it
struct HashContent {
    let key: [UInt8]
    let encryptedBytes: [UInt8]
}


/// Signing Manager based on SHA256 Hash
class HashSignatureManager: SignatureManager {
    typealias Content = HashContent
    typealias Signature = [UInt8]

    private func hash(_ content: Content) throws -> Signature {
        return try HMAC(key: content.key, variant: .sha256).authenticate(content.encryptedBytes)
    }

    func sign(content: Content) throws -> Signature {
        return try self.hash(content)
    }

    func verify(content: Content, signature: Signature) throws {
        let expectedHash = try self.hash(content)
        guard signature == expectedHash else {
            throw SignatureManagementError.badPasswordOrCorruptedData
        }
    }
}
