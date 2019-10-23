//
//  CipherSerializer.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 20/10/2019.
//

import Foundation


/// Errors that could occur while deserializing a Cipher Object
public enum BytesValidationError: Error {
    case invalidBytesNumber(_ bytes: [UInt8])
    case invalidHeader(_ bytes: [UInt8])
}

/// Errors that could occur while Serializing a Cipher Object
public enum CipherValidationError: Error {
    case invalidHeaderLength(_ cipher: Cipher)
    case invalidHeader(_ cipher: Cipher)
    case invalidSaltLength(_ cipher: Cipher)
    case invalidinitializationVectorLength(_ cipher: Cipher)
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
        return item.header + item.salt + item.initializationVector + item.encryptedBytes
    }

    public func deserialize(bytes: [UInt8]) throws -> Cipher {
        try self.validate(bytes: bytes)

        let saltStart = CipherConstants.headerLength
        let saltEnd = saltStart + CipherConstants.saltLength
        let salt = Array(bytes[saltStart..<saltEnd])

        let initializationVectorStart = saltEnd
        let initializationVectorEnd = initializationVectorStart + CipherConstants.initializationVectorLength
        let initializationVector = Array(bytes[initializationVectorStart..<initializationVectorEnd])

        let contentStart = initializationVectorEnd
        let contentEnd = bytes.count
        let content = Array(bytes[contentStart..<contentEnd])

        let cipher = Cipher(salt: salt, initializationVector: initializationVector, encryptedBytes: content)
        return cipher
    }

    private func validate(cipher: Cipher) throws {
        let rules: [ValidationRule<Cipher>] = [
            ValidationRule<Cipher>(
                predicate: { $0.header.count == CipherConstants.headerLength },
                error: { CipherValidationError.invalidHeaderLength($0) }
            ),
            ValidationRule<Cipher>(
                predicate: { $0.salt.count == CipherConstants.saltLength },
                error: { CipherValidationError.invalidSaltLength($0) }
            ),
            ValidationRule<Cipher>(
                predicate: { $0.initializationVector.count == CipherConstants.initializationVectorLength },
                error: { CipherValidationError.invalidinitializationVectorLength($0) }
            ),
            ValidationRule<Cipher>(
                predicate: { $0.header == CipherConstants.header },
                error: { CipherValidationError.invalidHeader($0) }
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
                predicate: { $0.count > CipherConstants.totalLength },
                error: { BytesValidationError.invalidBytesNumber($0) }
            ),
            ValidationRule<[UInt8]>(
                predicate: { Array($0[0..<CipherConstants.headerLength]) == CipherConstants.header },
                error: { BytesValidationError.invalidHeader($0) }
            )
        ]

        for rule in rules {
            guard rule.predicate(bytes) else {
                throw rule.error(bytes)
            }
        }
    }
}
