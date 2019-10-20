//
//  ReadSubCommand.swift
//  CryCommands
//
//  Created by Thibault Defeyter on 21/10/2019.
//

import Utility
import Files
import CryCipher


/// The read SubCommand
struct ReadSubCommand: SubCommand, FileManagementSubCommand, PassphrasedSubCommand {
    let name = "read"
    let overview = "Read a password encrypted file."

    var fileArgument: PositionalArgument<String>

    init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: self.name, overview: self.overview)
        self.fileArgument = subparser.add(
            positional: "file",
            kind: String.self,
            optional: false,
            usage: "The file to be read.",
            completion: nil
        )
    }

    func run(with arguments: ArgumentParser.Result) throws {
        let file = try self.file(from: arguments)
        let passphrase = self.promptPassphrase()
        print("\(self.name) \(file.name) with passphrase \(passphrase)")
        let cipher = try CipherSerializer().deserialize(bytes: try [UInt8](file.read()))
        let content = try CipherManager().decrypt(content: cipher, withSecret: [UInt8](passphrase.utf8))
        print(String(bytes: content, encoding: .utf8) ?? "unable to read UTF8 From Content")
    }

}
