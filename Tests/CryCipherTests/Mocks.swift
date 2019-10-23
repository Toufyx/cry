//
//  Mocks.swift
//  CryCipherTests
//
//  Created by Thibault Defeyter on 20/10/2019.
//

import Foundation
@testable import CryCipher

class EncryptionManagerStub: Manager {
    typealias ClearContent = [UInt8]
    typealias EncryptedContent = [UInt8]
    typealias Secret = EncryptionSecret

    private let encryptedBytes: EncryptedContent
    private let decryptedContent: ClearContent

    init(encryptedBytes: EncryptedContent? = nil, decryptedContent: ClearContent? = nil) {
        self.encryptedBytes = encryptedBytes ?? []
        self.decryptedContent = decryptedContent ?? []
    }

    func encrypt(content: [UInt8], withSecret secret: EncryptionSecret) throws -> [UInt8] {
        return self.encryptedBytes
    }

    func decrypt(content: [UInt8], withSecret secret: EncryptionSecret) throws -> [UInt8] {
        return self.decryptedContent
    }
}

class RandomGeneratorStub: RandomGenerator {
    private let randomBytesClosure: (UInt8) -> [UInt8]

    init(randomBytesClosure: @escaping (UInt8) -> [UInt8] = { [UInt8](0..<$0) }) {
        self.randomBytesClosure = randomBytesClosure
    }

    func generateRandomBytes(length: Int) throws -> [UInt8] {
        return self.randomBytesClosure(UInt8(length))
    }
}

class KeyCoupleGeneratorStub: KeyCoupleGenerator {
    private let keyCouple: KeyCouple

    init(keyCouple: KeyCouple) {
        self.keyCouple = keyCouple
    }

    convenience init(hashKey: [UInt8]? = nil, encryptionKey: [UInt8]? = nil) {
        self.init(keyCouple: KeyCouple(hashKey: hashKey ?? [], encryptionKey: encryptionKey ?? []))
    }

    func generateKeyCouple(fromPassword password: [UInt8], andSalt salt: [UInt8]) throws -> KeyCouple {
        return self.keyCouple
    }
}
