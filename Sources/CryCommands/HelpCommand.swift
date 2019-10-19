//
//  HelpCommand.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//


/// Help Command
struct HelpCommand: Command {
    var command: String = "help"
    var usage: String = "cry help"
    var overview: String = "Show this help message"

    /// Empty constructor for protocol compliance
    init() {}

    /// Write down the rooting dispatch
    /// Expect subcommands and their descriptions listed like this:
    /// [command-1, description-1, command-2, description-2, ...]
    func run(with arguments: [String]) throws {
        print("OVERVIEW: manage encryption for files")
        print("")
        print("USAGE: cry [command] <FILE>")
        print("")
        print("SUBCOMMANDS:")
        var index = 0
        while index < arguments.count {
            let formattedCommand = arguments[index].withCString{
                String(format: "  %-18s", $0)
            }
            print("\(formattedCommand) \(arguments[index+1])")
            index = index + 2
        }
    }
}
