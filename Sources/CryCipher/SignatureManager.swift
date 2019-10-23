//
//  SignatureManager.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 23/10/2019.
//

/// Class Interface
protocol SignatureManager {
    associatedtype Content
    associatedtype Signature

    func sign(content: Content) throws -> Signature
    func verify(content: Content, signature: Signature) throws
}


/// Error that could occur while Signing or Verifing a message
enum SignatureManagementError: Error {
    case badPasswordOrCorruptedData
}


/// Keep Calm and Type Erase
class AnySignatureManager<C, S>: SignatureManager {
    typealias Content = C
    typealias Signature = S

    private let proxySign: (Content) throws -> Signature
    private let proxyVerify: (Content, Signature) throws -> Void

    init<U: SignatureManager>(manager: U) where U.Content == C, U.Signature == S {
        self.proxySign = manager.sign
        self.proxyVerify = manager.verify
    }

    func sign(content: Content) throws -> Signature {
        return try self.proxySign(content)
    }

    func verify(content: Content, signature: Signature) throws {
        return try self.proxyVerify(content, signature)
    }
}
