//
//  CommandRooter.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility


class CommandRooter {
    private var commands: [Command] = []
    private var defaultCommand: Command = HelpCommand()
    
    func register(_ command: Command.Type, isDefault: Bool = false) {
        self.commands.append(command.init())
        if isDefault {
            self.defaultCommand = command.init()
        }
    }
    
    func run() {
        var arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
        var command = self.defaultCommand
        do {

            // root to help command for fallback
            if arguments.count == 0 || arguments[0].contains("help") {
                command = HelpCommand()
                try command.run(with: self.commands.flatMap({[$0.command, $0.overview]}))
                exit(0)
            }
        
            // root to appropriate command if all good
            if let argumentCommand = self.commands.first(where: {$0.command == arguments[0]}) {
                arguments.removeFirst()
                command = argumentCommand
            }
            try command.run(with: arguments)
            exit(0)

        } catch let error as ArgumentParserError {
            print(error.description)
            exit(1)
        } catch let error {
            print(error.localizedDescription)
            exit(1)
        }
    }
}
