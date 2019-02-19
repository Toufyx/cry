//
//  ReadCommand.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility


/// Read Command (default) 
struct ReadCommand: Command, FileManagementCommand {
    var command: String = "read"
    var usage: String = "read <FILE>"
    var overview: String = "Read a given encrypted file."
    
    var parser: ArgumentParser
    var file: PositionalArgument<String>
    
    init() {
        self.parser = ArgumentParser(usage: self.usage, overview: self.overview)
        self.file = self.parser.add(
            positional: "file",
            kind: String.self,
            optional: false,
            usage: "The file to be read.",
            completion: nil
        )
    }
}
