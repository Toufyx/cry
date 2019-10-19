//
//  Manager.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 20/10/2019.
//

import Foundation


/// Common Interface for all Managers
protocol Manager {

    associatedtype ClearContent
    associatedtype EncryptedContent
    associatedtype Secret

    func encrypt(content: ClearContent, withSecret secret: Secret) throws -> EncryptedContent
    func decrypt(content: EncryptedContent, withSecret secret: Secret) throws -> ClearContent
}


/// Keep Calm and Type Erase
class AnyManager<C, E, S> {

    typealias ClearContent = C
    typealias EncryptedContent = E
    typealias Secret = S

    private let proxyEncrypt: (ClearContent, Secret) throws -> EncryptedContent
    private let proxyDecrypt: (EncryptedContent, Secret) throws -> ClearContent

    init<U: Manager>(manager: U) where U.ClearContent == C, U.EncryptedContent == E, U.Secret == Secret {
        self.proxyEncrypt = manager.encrypt
        self.proxyDecrypt = manager.decrypt
    }

    func encrypt(content: ClearContent, withSecret secret: Secret) throws -> EncryptedContent {
        return try self.proxyEncrypt(content, secret)
    }

    func decrypt(content: EncryptedContent, withSecret secret: Secret) throws -> ClearContent {
        return try self.proxyDecrypt(content, secret)
    }
}
