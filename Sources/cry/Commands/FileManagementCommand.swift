//
//  FileManagementCommand.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Basic
import Utility
import Files


/// Shared protocol for all command taking one file as argument
/// Example:
///     cli command <FILE>
protocol FileManagementCommand {
    var parser: ArgumentParser { get }
    var file: PositionalArgument<String> { get }
    func process(file: File)
}


/// Default implementation for Command instances
extension FileManagementCommand where Self: Command {
    
    /// Default running parses the arguments and process the file
    func run(with arguments: [String]) throws {
        let result = try self.parser.parse(arguments)
        guard let filePath = result.get(self.file) else {
            throw ArgumentParserError.expectedArguments(self.parser, ["file"])
        }
        do {
            try self.process(file: File(path:filePath))
        } catch let error as Files.FileSystem.Item.PathError {
            throw ArgumentParserError.invalidValue(argument: "file", error: .custom(error.description))
        }
    }
    
    /// Default implementation of file processing does nothing
    /// Method to be overwritten in protocols implementation
    func process(file: File) {
        print("\(self.command): \(file.name)")
    }
}
