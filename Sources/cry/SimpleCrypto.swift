//
//  Cryptography.swift
//  Basic
//
//  Created by Thibault Defeyter on 23/02/2019.
//

import Foundation
import CryptoSwift


/// Error that could occur while plyaing with randomness
enum RandomGenerationError: Error {
    case failure(_ reason: String)
}


/// Simple Struct to manage password-only cryptography
struct SimpleCrypto {

    /// Header to be added in the encrypted file to identify the tool and its version that encrypted it.
    /// TODO: use it for tool/version validation before trying to decrypt file.
    static let header = "cryV0"
    static let headerLength = 5

    /// Encrypt Data with the given passphrase
    static func encrypt(_ data: Data, passphrase: String) throws -> Data {

        // extract the content to be encrypted
        let content = self.bytes(fromData: data)

        // transform the passphrase into an array of Bytes
        let password = self.bytes(fromString: passphrase)

        // transform the header into an array of Bytes
        let header = self.bytes(fromString: SimpleCrypto.header)

        // generate random salt and iv for key generation
        let salt = try self.randomBytes(length: 16)
        let iv = try self.randomBytes(length: 16)

        // generate a key from passphrase, salt and iv
        let key = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, variant: .sha256).calculate()

        // encrypt the data usiong AES256
        let encrypted_bytes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(content)

        // return the encrypted data:
        // [HEADER: headerLength][SALT: 16][iv: 16][content]
        return Data(bytes: header + salt + iv + encrypted_bytes)
    }

    /// Decrypt data with given passphrase
    static func decrypt(_ data: Data, passphrase: String) throws -> Data {

        // extract the data to be decrypted
        let data = self.bytes(fromData: data)

        // transform the passphrase into an array of Bytes
        let password = self.bytes(fromString: passphrase)

        // extract the salt, iv and content from data to be decrypted
        // [HEADER: headerLength][SALT: 16][iv: 16][content]
        let salt = self.bytes(fromBytes: data, offset: SimpleCrypto.headerLength, count: 16)
        let iv = self.bytes(fromBytes: data, offset: SimpleCrypto.headerLength + 16, count: 16)
        let content = self.bytes(fromBytes: data, offset: SimpleCrypto.headerLength + 32)

        // generate a key from passphrase, salt and iv contained in the data
        let key = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, variant: .sha256).calculate()

        // decrypt the content using the generated key
        let decrypted_bytes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(content)

        // return the decrypted content
        return Data(bytes: decrypted_bytes)
    }

    /// Extract Bytes from an array of Bytes
    private static func bytes(fromBytes bytes: [UInt8], offset: Int = 0, count: Int? = nil) -> [UInt8] {
        let count = count ?? bytes.count - offset
        return Array(bytes[offset..<offset+count])
    }

    /// Get Bytes from Data
    private static func bytes(fromData data: Data) -> [UInt8] {
        return [UInt8](data)
    }

    /// Get Bytes from String
    private static func bytes(fromString string: String) -> [UInt8] {
        return [UInt8](string.utf8)
    }

    /// Generate array of random Bytes
    private static func randomBytes(length: Int) throws -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        guard status == errSecSuccess else {
            throw RandomGenerationError.failure("error generating random bytes")
        }
        return bytes
    }
}
