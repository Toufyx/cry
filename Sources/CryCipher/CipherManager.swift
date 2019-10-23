//
//  CipherManager.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 23/02/2019.
//

import Foundation
import CryptoSwift


/// Cipher related Constants
struct CipherConstants {
    static let headerLength = 8
    static let saltLength = 32
    static let initializationVectorLength = 16
    static let hashLength = 32
    static let totalLength = headerLength + saltLength + initializationVectorLength + hashLength
    static let currentVersion = 0
    static let header = [UInt8]("CRY00001".utf8)
}


/// The Cipher to be written/read from the encrypted file
public struct Cipher: Equatable {
    let header: [UInt8] = CipherConstants.header
    let salt: [UInt8]
    let initializationVector: [UInt8]
    let encryptedBytes: [UInt8]
    let hash: [UInt8]
}


/// Manage Ciphers Encryption/Decryption
public struct CipherManager: Manager {
    public typealias ClearContent = [UInt8]
    public typealias EncryptedContent = Cipher
    public typealias Secret = [UInt8]

    private let encryptionManager: AnyManager<[UInt8], [UInt8], EncryptionSecret>
    private let randomGenerator: RandomGenerator
    private let keyCoupleGenerator: KeyCoupleGenerator
    private let signatureManager: AnySignatureManager<HashContent, [UInt8]>

    init(encryptionManager: AnyManager<[UInt8], [UInt8], EncryptionSecret>,
         randomGenerator: RandomGenerator,
         keyCoupleGenerator: KeyCoupleGenerator,
         signatureManager: AnySignatureManager<HashContent, [UInt8]>) {
        self.encryptionManager = encryptionManager
        self.randomGenerator = randomGenerator
        self.keyCoupleGenerator = keyCoupleGenerator
        self.signatureManager = signatureManager
    }

    public init() {
        self.init(
            encryptionManager: AnyManager(manager: EncryptionManager()),
            randomGenerator: RandomGeneratorImpl(),
            keyCoupleGenerator: KeyCoupleGeneratorImpl(),
            signatureManager: AnySignatureManager(manager: HashSignatureManager())
        )
    }

    public func encrypt(content: ClearContent, withSecret secret: Secret) throws -> EncryptedContent {

        // generate random salt and init vector for key generation
        let salt = try self.randomGenerator.generateRandomBytes(length: CipherConstants.saltLength)
        let initializationVector = try self.randomGenerator.generateRandomBytes(
            length: CipherConstants.initializationVectorLength
        )

        // generate a key from secret and salt
        let key = try self.keyCoupleGenerator.generateKeyCouple(fromPassword: secret, andSalt: salt)

        // encrypt the data using AES256 (key and init vector)
        let encryptedBytes = try self.encryptionManager.encrypt(
            content: content,
            withSecret: EncryptionSecret(key: key.encryptionKey, initializationVector: initializationVector)
        )

        // compute the hash of the encrypted data
        let hash = try self.signatureManager.sign(
            content: HashContent(
                key: key.hashKey,
                encryptedBytes: encryptedBytes
            )
        )

        return Cipher(
            salt: salt,
            initializationVector: initializationVector,
            encryptedBytes: encryptedBytes,
            hash: hash
        )
    }

    public func decrypt(content: EncryptedContent, withSecret secret: Secret) throws -> ClearContent {

        // generate a key from secret and salt
        let key = try self.keyCoupleGenerator.generateKeyCouple(fromPassword: secret, andSalt: content.salt)

        // verify the hash of the encrypted data
        try self.signatureManager.verify(
            content: HashContent(key: key.hashKey, encryptedBytes: content.encryptedBytes),
            signature: content.hash
        )

        // decrypt the data using AES256 (key and init vector)
        let decryptedBytes = try self.encryptionManager.decrypt(
            content: content.encryptedBytes,
            withSecret: EncryptionSecret(key: key.encryptionKey, initializationVector: content.initializationVector)
        )

        return decryptedBytes
    }
}
