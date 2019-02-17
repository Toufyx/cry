//
//  DecryptCommand.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility


struct DecryptCommand: Command, FileManagementCommand {
    var command: String = "decrypt"
    var usage: String = "decrypt <FILE>"
    var overview: String = "Decrypt a given files."
    
    var parser: ArgumentParser
    var file: PositionalArgument<String>
    
    init() {
        self.parser = ArgumentParser(usage: self.usage, overview: self.overview)
        self.file = self.parser.add(
            positional: "file",
            kind: String.self,
            optional: false,
            usage: "The file to be decrpyted.",
            completion: nil
        )
    }
}
