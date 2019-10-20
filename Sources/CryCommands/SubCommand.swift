//
//  SubCommand.swift
//  CryCommands
//
//  Created by Thibault Defeyter on 21/10/2019.
//

import Foundation
import Utility
import Files


/// Common SubCommand Interface
protocol SubCommand {

    var name: String { get }
    var overview: String { get }

    init(parser: ArgumentParser)
    func run(with arguments: ArgumentParser.Result) throws
}


/// File Management SubCommands Interface
protocol FileManagementSubCommand {
    var fileArgument: PositionalArgument<String> { get }
    func file(from arguments: ArgumentParser.Result) throws -> File
}


/// Eror that could occur while managing files
enum FileManagementError: Error {
    case missingFileName(arguments: ArgumentParser.Result)
}


/// File Management SubCommands Default Implementation
extension FileManagementSubCommand {
    func file(from arguments: ArgumentParser.Result) throws -> File {
        guard let filepath = arguments.get(self.fileArgument) else {
            throw FileManagementError.missingFileName(arguments: arguments)
        }
        return try File(path: filepath)
    }
}


/// Passphrased SubCommands Interface
protocol PassphrasedSubCommand {
    func promptPassphrase() -> String
}


/// Passphrased SubCommands Default Implementation
extension PassphrasedSubCommand {
    func promptPassphrase() -> String {
        guard let passphrase = getpass("Enter passphrase: ") else {
            return ""
        }

        guard let passphraseString = String.init(validatingUTF8: passphrase) else {
            return ""
        }

        return passphraseString
    }
}
