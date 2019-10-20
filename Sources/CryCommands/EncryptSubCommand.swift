//
//  EncryptSubCommand.swift
//  CryCommands
//
//  Created by Thibault Defeyter on 21/10/2019.
//

import Utility
import Files


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
        print("\(self.name) \(file.name) with passphrase \(passphrase)")
    }
}
