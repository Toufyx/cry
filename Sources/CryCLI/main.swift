//
//  main.swift
//  CryCLI
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import CryCommands

let cry = CryCommand()

do {
    try cry.run(argc: Int(CommandLine.argc), argv: CommandLine.arguments)
} catch {
    print("Whoops! An unexpected error occurred: \(error)")
}
