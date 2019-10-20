//
//  EncryptSubCommand.swift
//  CryCommands
//
//  Created by Thibault Defeyter on 21/10/2019.
//

import Foundation
import Utility
import Files
import CryCipher


/// The encrypt SubCommand
struct EncryptSubCommand: SubCommand, FileManagementSubCommand, PassphrasedSubCommand {
    let name = "encrypt"
    let overview = "Encrypt a file with a password."

    var fileArgument: PositionalArgument<String>

    init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: self.name, overview: self.overview)
        self.fileArgument = subparser.add(
            positional: "file",
            kind: String.self,
            optional: false,
            usage: "The file to be encrypted.",
            completion: nil
        )
    }

    func run(with arguments: ArgumentParser.Result) throws {
        let file = try self.file(from: arguments)
        let passphrase = self.promptPassphrase()
        print("encrypting \(file.name) with passphrase \(passphrase)...")
        let cipher = try CipherManager().encrypt(content: try [UInt8](file.read()), withSecret: [UInt8](passphrase.utf8))
        let content = try CipherSerializer().serialize(item: cipher)
        try file.write(data: Data(bytes: content))
        print("encryption succeeded")
    }
}
