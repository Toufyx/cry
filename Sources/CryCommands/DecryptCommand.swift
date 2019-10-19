//
//  DecryptCommand.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility
import Files


/// Decrypt command
struct DecryptCommand: Command, FileManagementCommand, PassphrasedCommand {
    var command: String = "decrypt"
    var usage: String = "decrypt <FILE>"
    var overview: String = "Decrypt a given files."

    var parser: ArgumentParser
    var file: PositionalArgument<String>

    init() {
        self.parser = ArgumentParser(usage: self.usage, overview: self.overview)
        self.file = self.parser.add(
            positional: "file",
            kind: String.self,
            optional: false,
            usage: "The file to be decrpyted.",
            completion: nil
        )
    }

    /// Default implementation of file processing does nothing
    /// Method to be overwritten in protocols implementation
    func process(file: File) throws {
        let passphrase = self.getPassphrase()
        print("\(self.command): \(file.name) with passphrase: \(passphrase)")
    }
}
