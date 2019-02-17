//
//  FileManagementCommand.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility


protocol FileManagementCommand {
    var parser: ArgumentParser { get }
    var file: PositionalArgument<String> { get }
    func process(file: String?)
}


extension FileManagementCommand where Self: Command {
    
    func run(with arguments: [String]) throws {
        let result = try self.parser.parse(arguments)
        self.process(file: result.get(self.file))
    }
    
    func process(file: String?) {
        print("\(self.command): \(String(describing: file))")
    }
}
