//
//  SubCommandRegistry.swift
//  CryCommands
//
//  Created by Thibault Defeyter on 21/10/2019.
//

import Utility


/// Error that can occur while managing SubCommands
enum SubCommandRegistryError: Error {
    case subcommandNotRegistered(name: String)
}


/// The SubCommands Registry
struct SubCommandRegistry {
    private var subcommands: [SubCommand] = []

    /// Register a command to the registry for a given parser
    mutating func register(subcommand: SubCommand.Type, to parser: ArgumentParser) {
        self.subcommands.append(subcommand.init(parser: parser))
    }

    /// Return the subcommand called in arguments for given parser.
    func subcommand(for parsedArgumentResult: ArgumentParser.Result, with parser: ArgumentParser) throws -> SubCommand {
        let subparser = parsedArgumentResult.subparser(parser)
        guard let subcommand = self.subcommands.first(where: { $0.name == subparser }) else {
            throw SubCommandRegistryError.subcommandNotRegistered(name: subparser ?? "")
        }
        return subcommand
    }

}
