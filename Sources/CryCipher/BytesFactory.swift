//
//  BytesFactory.swift
//  CryCipher
//
//  Created by Thibault Defeyter on 23/02/2019.
//

import Foundation


/// Mockable Interface
protocol BytesFactory {
    func bytes(fromBytes bytes: [UInt8], offset: Int, count: Int?) -> [UInt8]
    func bytes(fromData data: Data) -> [UInt8]
    func bytes(fromString string: String) -> [UInt8]
}

/// Manage Bytes transformation
struct BytesFactoryImpl: BytesFactory {

    /// Extract Bytes from an array of Bytes
    func bytes(fromBytes bytes: [UInt8], offset: Int = 0, count: Int? = nil) -> [UInt8] {
        let count = count ?? bytes.count - offset
        return Array(bytes[offset..<offset+count])
    }

    /// Get Bytes from Data
    func bytes(fromData data: Data) -> [UInt8] {
        return [UInt8](data)
    }

    /// Get Bytes from String
    func bytes(fromString string: String) -> [UInt8] {
        return [UInt8](string.utf8)
    }
}
