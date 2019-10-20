//
//  CryCommand.swift
//  CryCommands
//
//  Created by Thibault Defeyter on 20/10/2019.
//

import Utility


// Main class to be run in script
public struct CryCommand: Command {
    let usage = "[command] [file]"
    let overview = "Simple tool managing password encrypted files."

    let parser: ArgumentParser
    var registry = SubCommandRegistry()

    public init() {
        self.parser = ArgumentParser(usage: self.usage, overview: self.overview)
        self.registry.register(subcommand: ReadSubCommand.self, to: self.parser)
        self.registry.register(subcommand: EncryptSubCommand.self, to: self.parser)
        self.registry.register(subcommand: DecryptSubCommand.self, to: self.parser)
    }

    public func run(argc: Int, argv: [String]) throws {
        let arguments = Array(argv.dropFirst())
        let parsedArguments = try parser.parse(arguments)
        let subcommand = try self.registry.subcommand(for: parsedArguments, with: self.parser)
        try subcommand.run(with: parsedArguments)
    }
}
