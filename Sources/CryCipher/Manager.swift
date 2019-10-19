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
