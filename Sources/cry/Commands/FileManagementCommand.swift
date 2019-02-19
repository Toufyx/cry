//
//  FileManagementCommand.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility


/// Shared protocol for all command taking one file as argument
/// Example:
///     cli command <FILE>
protocol FileManagementCommand {
    var parser: ArgumentParser { get }
    var file: PositionalArgument<String> { get }
    func process(file: String?)
}


/// Default implementation for Command instances
extension FileManagementCommand where Self: Command {
    
    /// Default running parses the arguments and process the file
    func run(with arguments: [String]) throws {
        let result = try self.parser.parse(arguments)
        self.process(file: result.get(self.file))
    }
    
    /// Default implementation of file processing does nothing
    /// Method to be overwritten in protocols implementation
    func process(file: String?) {
        print("\(self.command): \(String(describing: file))")
    }
}
