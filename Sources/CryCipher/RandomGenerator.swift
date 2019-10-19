//
//  RandomManager.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 19/10/2019.
//

import Foundation
import CryptoSwift


/// Error that could occur while playing with randomness
enum RandomGenerationError: Error {
    case failure(_ reason: String)
}

/// Mockable Interface
protocol RandomGenerator {
    func generateRandomBytes(length: Int) throws -> [UInt8]
}

/// Generate Randomness in all its ways.
public struct RandomGeneratorImpl: RandomGenerator {

    /// Generate array of random Bytes
    func generateRandomBytes(length: Int) throws -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        guard status == errSecSuccess else {
            throw RandomGenerationError.failure("error generating random bytes")
        }
        return bytes
    }

}
