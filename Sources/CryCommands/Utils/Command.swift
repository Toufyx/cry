//
//  Command.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility


/// Common protocol for CLI subcommands
protocol Command {
    
    /// Expose the command name
    var command: String { get }
    
    /// Expose the usage
    var usage: String { get }
    
    /// Expose a quick overview of the subcommand
    var overview: String { get }
    
    /// Expose an empty creator
    init()
    
    /// Main method: running the command
    func run(with arguments: [String]) throws
}
