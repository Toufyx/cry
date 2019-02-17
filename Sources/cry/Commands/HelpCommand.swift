//
//  HelpCommand.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation


struct HelpCommand: Command {
    var command: String = "help"
    var usage: String = ""
    var overview: String = ""
    
    init() {}
    
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
