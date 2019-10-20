//
//  CipherSerializer.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 20/10/2019.
//

import Foundation


/// Errors that could occur while deserializing a Cipher Object
public enum DataValidationError: Error {
    case invalidBytesNumber(_ bytes: [UInt8])
    case invalidHeader(_ bytes: [UInt8])
    case deprecatedHeader(_ bytes: [UInt8])
}

/// Errors that could occur while Serializing a Cipher Object
public enum CipherValidationError: Error {
    case invalidHeaderLength(_ cipher: Cipher)
    case invalidHeader(_ cipher: Cipher)
    case deprecatedHeader(_ cipher: Cipher)
    case invalidSaltLength(_ cipher: Cipher)
    case invalidInitVectorLength(_ cipher: Cipher)
}


/// Wrapper around a validation predicate and an error raised when given predicate fails
struct ValidationRule<Item> {
    let predicate: (Item) -> (Bool)
    let error: (Item) -> (Error)
}


/// Serialize/Deserialize Data into Cipher and validate the inpout data
public struct CipherSerializer {

    public init() {}

    public func serialize(item: Cipher) throws -> [UInt8] {
        try self.validate(cipher: item)
        return item.header + item.salt + item.initializationVector + item.encryptedContent
    }

    public func deserialize(bytes: [UInt8]) throws -> Cipher {
        try self.validate(bytes: bytes)

        let saltStart = Cipher.headerLength
        let saltEnd = saltStart + Cipher.saltLength
        let salt = Array(bytes[saltStart..<saltEnd])

        let initVectorStart = saltEnd
        let initVectorEnd = initVectorStart + Cipher.initializationVectorLength
        let initVector = Array(bytes[initVectorStart..<initVectorEnd])

        let contentStart = initVectorEnd
        let contentEnd = bytes.count
        let content = Array(bytes[contentStart..<contentEnd])

        let cipher = Cipher(salt: salt, initializationVector: initVector, encryptedContent: content)
        return cipher
    }

    private func validate(cipher: Cipher) throws {
        let rules: [ValidationRule<Cipher>] = [
            ValidationRule<Cipher>(
                predicate: { $0.header.count == Cipher.headerLength },
                error: { CipherValidationError.invalidHeaderLength($0) }
            ),
            ValidationRule<Cipher>(
                predicate: { $0.salt.count == Cipher.saltLength },
                error: { CipherValidationError.invalidSaltLength($0) }
            ),
            ValidationRule<Cipher>(
                predicate: { $0.initializationVector.count == Cipher.initializationVectorLength },
                error: { CipherValidationError.invalidInitVectorLength($0) }
            ),
            ValidationRule<Cipher>(
                predicate: { Cipher.headers.contains($0.header) },
                error: { CipherValidationError.invalidHeader($0) }
            ),
            ValidationRule<Cipher>(
                predicate: { $0.header == Cipher.currentHeader },
                error: { CipherValidationError.deprecatedHeader($0) }
            )
        ]

        for rule in rules {
            guard rule.predicate(cipher) else {
                throw rule.error(cipher)
            }
        }
    }

    private func validate(bytes: [UInt8]) throws {
        let rules: [ValidationRule<[UInt8]>] = [
            ValidationRule<[UInt8]>(
                predicate: { $0.count > Cipher.headerLength + Cipher.saltLength + Cipher.initializationVectorLength },
                error: { DataValidationError.invalidBytesNumber($0) }
            ),
            ValidationRule<[UInt8]>(
                predicate: { Cipher.headers.contains(Array($0[0..<Cipher.headerLength])) },
                error: {DataValidationError.invalidHeader($0) }
            ),
            ValidationRule<[UInt8]>(
                predicate: { Array($0[0..<Cipher.headerLength]) == Cipher.currentHeader },
                error: { DataValidationError.deprecatedHeader($0) }
            )
        ]

        for rule in rules {
            guard rule.predicate(bytes) else {
                throw rule.error(bytes)
            }
        }
    }
}
