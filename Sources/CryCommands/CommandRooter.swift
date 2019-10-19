//
//  CommandRooter.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility


/// Root arguments to the right SubCommand
public final class CommandRooter {

    /// List of subcommands registered
    private var commands: [Command] = []

    /// The default subcommand -> `help` by default -> can be overwritten
    private var defaultCommand: Command = HelpCommand()

    public init() {
        self.register(EncryptCommand.self)
        self.register(DecryptCommand.self)
        self.register(ReadCommand.self, isDefault: true)
    }

    public func run() throws {
        self.process(Array(ProcessInfo.processInfo.arguments.dropFirst()))
    }

    /// Register a subcommand
    /// Args:
    ///     - command (Command.Type): a command class to be registered on the rooter
    ///     - isDefault (bool): whether the command should take the default's place
    func register(_ command: Command.Type, isDefault: Bool = false) {
        self.commands.append(command.init())
        if isDefault {
            self.defaultCommand = command.init()
        }
    }

    /// Process the given arguments
    func process(_ arguments: [String]) {
        var command = self.defaultCommand
        var subcommandArguments = arguments
        do {

            // if no arguments were passed to the CLI or if help, -help, --help
            // or whatever containing help is passed as first argument then run the help command
            if arguments.count == 0 || arguments[0].contains("help") {
                try HelpCommand().run(with: self.commands.flatMap({[$0.command, $0.overview]}))
                exit(0)
            }

            // otherwise root to the appropriate command if one is present ( or default otherwise )
            if let argumentCommand = self.commands.first(where: {$0.command == arguments[0]}) {
                subcommandArguments.removeFirst()
                command = argumentCommand
            }
            try command.run(with: subcommandArguments)
            exit(0)

        // catch ArgumentParserError to pretty print their error
        } catch let error as ArgumentParserError {
            print(error.description)
            exit(1)

        // or just print anything that went wrong !
        } catch let error {
            print(error.localizedDescription)
            exit(1)
        }
    }
}
